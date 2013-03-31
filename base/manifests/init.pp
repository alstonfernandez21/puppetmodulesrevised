class base {
        $passenger_packages = [ "gcc-c++", "make", "automake", "libjpeg-devel", "giflib-devel", "freetype-devel", "bison", "patch", "readline", "readline-devel", "zlib", "zlib-devel", "libyaml-devel", "libffi-devel", "openssl-devel", "curl-devel", "git", "curl", "libtool", "libxml2-devel", "libxslt-devel", "bzip2", ]
        package { $passenger_packages:
       before  => Exec["install_rvm"],
        }
#TO ADDRESS SSH LOGIN TIME ISSUE GSSAPI AUTHENTICATION DISABLED 
file {"/etc/ssh/sshd_config":
    owner => "root",
    group => "root",
    mode => 0600,
    source    => 'puppet:///modules/base/sshd_config',
    notify  => Service["sshd"], 
    }

service { "sshd":
    	 ensure  => "running",
         hasstatus  => true,
         hasrestart => true,
         enable     => true,
}

file {"/opt/rvm_default.sh":
    owner => "root",
    group => "root",
    mode => 0755,
    source    => 'puppet:///modules/base/opt/rvm_default.sh',
    }

exec { "install_rvm":
    command  => "sh /opt/rvm_default.sh",
    timeout  => 100000,
    path     => "/bin/:/usr/bin/",
    require  => File["/opt/rvm_default.sh"],
    #unless   => "ls /usr/local/rvm/bin/rvm",
    }
   
 file { [ "/data", ]:
    	owner => "root",
	group => "root",
    	ensure => "directory",
    	mode   => 0760,
 }
 
 file { [ "/data/web", "/data/rails", ]:
	owner => "root",
	group => "root",
	ensure => "directory",
	mode => "0660",
	require => File["/data"],
 }


 file { "/data/ssl":
	owner => "root",
	group => "root",
	ensure => "directory",
	mode   => 0650,
 }

 file { [ "/data/log", "/data/backup", ]:
	owner => "root",
	group => "root",
	ensure => "directory",
	mode => 0650,
	require => File["/data"],
 }
	
 file { [ "/data/backup/mysql", "/data/backup/mongodb", "/data/backup/redis", ]:
    	owner => "root",
    	ensure => "directory",
    	mode   => 0650,
	require => File["/data/backup"],
 }

 file { ["/data/log/mysql"]:
	owner => "root",
	group => "mysql",
	mode => "0660",
	ensure => "directory",
	require => File["/data/log"],
 }

 user { "deploy":
      ensure => "present",
      comment => "Deploy User",
      home => "/home/deploy",
      shell => "/bin/bash",
      managehome => true,
      before => [Exec["deploy-user-setfacl"], Exec["deploy-user-setfacl1"], ],
  }

  file { "/home/deploy":
	mode => 700,
        require => User["deploy"]
  }

  exec { "deploy-user-setfacl":
    command  => "setfacl -Rdm u:deploy:rwx /data",
    timeout  => 100000,
    path     => "/bin/:/usr/bin/",
    require  => File["/data"],
   }

  exec { "deploy-user-setfacl1":
    command  => "setfacl -Rm u:deploy:rwx /data",
    timeout  => 100000,
    path     => "/bin/:/usr/bin/",
    require  => File["/data"],
   }

# ADD rtsadmin GLOBAL ADMIN user KEYS HERE
 ssh_authorized_key {
        "rtsadmin@domu02":
                ensure  => present,
                user    => rtsadmin,
                type    => "ssh-dss",
                key     => "BLAA";
}


file {"/etc/puppet/puppet.conf":
    owner => "root",
    group => "root",
    mode => 0600,
    source    => 'puppet:///modules/base/puppet.conf',
}






}
