class base {
        $passenger_packages = [ "gcc-c++", "make", "automake", "libjpeg-devel", "giflib-devel", "freetype-devel", "bison", "patch", "readline", "readline-devel", "zlib", "zlib-devel", "libyaml-devel", "libffi-devel", "openssl-devel", "curl-devel", "git", "curl", ]
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
   
 file { [ "/data", "/data/log",
         "/data/web", "/data/backup", 
	"/data/rails", ]:
    	owner => "root",
    	ensure => "directory",
    	mode   => 0765,
 }

 file { "/data/ssl":
	owner => "root",
	group => "root",
	ensure => "directory",
	mode   => 0750,
 }

 file { [ "/data/backup/mysql", "/data/backup/mongodb", "/data/backup/redis", ]:
    	owner => "root",
    	ensure => "directory",
    	mode   => 0665,
	require => File["/data/backup"],
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





}