class passenger-nginx {
	$passenger_packages = [ "gcc-c++", "patch", "readline", "readline-devel", "zlib", "zlib-devel", "libyaml-devel", "libffi-devel", "openssl-devel", "curl-devel", "git", "curl", ]
	package { $passenger_packages: 
	before	=> Exec["install_rvm"],
	}

file {"/opt/rvm_default.sh":
    owner => "root",
    group => "root",
    mode => 0755,
    source    => 'puppet:///modules/passenger-apache/opt/rvm_default.sh',
    }

exec { "install_rvm":
    command  => "sh /opt/rvm_default.sh",
    timeout  => 100000,
    path     => "/bin/:/usr/bin/",
    require  => File["/opt/rvm_default.sh"],
    }



}

