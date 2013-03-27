class base {
        $passenger_packages = [ "gcc-c++", "make", "automake", "libjpeg-devel", "giflib-devel", "freetype-devel", "bison", "patch", "readline", "readline-devel", "zlib", "zlib-devel", "libyaml-devel", "libffi-devel", "openssl-devel", "curl-devel", "git", "curl", "libtool", "libxml2-devel", "libxslt-devel", ]
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

# ADD rtsadmin GLOBAL ADMIN user KEYS HERE
 ssh_authorized_key {
        "rtsadmin@domu02":
                ensure  => present,
                user    => rtsadmin,
                type    => "ssh-dss",
                key     => "AAAAB3NzaC1kc3MAAACBAMSyWse30JQiioKZyBNkD+rOc0HRqsAZlgFM9ou1gy/CyMaQOSf9cNpLnKy8jgqOrS2/tqfeFeYy2R3Eg9qhfZSCq1mokXYW2ornIWUkXFF7K7lhesYhgWtwKPRm8avz+MWXagKSj93YYTEF4r8ctzf6+t0x0xETC5mneK9vh0NvAAAAFQDoiSq5QMAjXocnGl5gWjK80rR5rQAAAIBQpKBoIfJARc1kKUwcEWo6UowPtVcAVl/jtbFic3Kh573ZeETruGcWJ6SHOtVTvdI2wrabBdOaFk44DmQNEoB9MPVPEJ/8M1MA5imsB+8sFLJbweJNH/Ht0dKvmjgm1q12R5hzaopL84ncLuKrI0oFdL7f/1UcA1qMzdCo7ZfHvQAAAIAqY9bYtbVk9NmJNsTelaSxU1aLNThalHDmG9BF+type2MjUn4UK3h6oH+Iov7Q6oVVLhrFTML0pvOaMlCe5MLXDPhqndxXz1wHwk9VHHPFSnSvSWOO/R+PYXUvWHiKTHyvFv7ZYz2ANmEv9W4c4UElT3fv/LjyVM/pIC7SoZqz7A== rtsadmin@domU2.rts.lan";
}

}
