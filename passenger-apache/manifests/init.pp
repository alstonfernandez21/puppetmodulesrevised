class passenger-apache {
	$passenger_packages = [ "gcc-c++", "patch", "readline", "readline-devel", "zlib", "zlib-devel", "libyaml-devel", "libffi-devel", "openssl-devel", "curl-devel" ]
	package { $passenger_packages: }

file {"/opt/rvm_default.sh":
    owner => "root",
    group => "root",
    mode => 0755,
    source    => 'puppet:///modules/passenger-apache/opt/rvm_default.sh',
    }


file {"/opt/passenger_install.sh":
    owner => "root",
    group => "root",
    mode => 0755,
    source    => 'puppet:///modules/passenger-apache/opt/passenger_install.sh',
    before => Exec["install_passenger"],
    }

exec { "install_passenger":
    command  => "sh /opt/passenger_install.sh",
    timeout  => 100000,
    path     => "/bin/:/usr/bin/",
    before   => Exec["passenger_compile"],
    }



exec { "install_rvm":
    command  => "sh /opt/rvm_default.sh",
    timeout  => 100000,
    path     => "/bin/:/usr/bin/",
    require  => File["/opt/rvm_default.sh"],
    before => File["/opt/passenger_install.sh"],
    }


exec { "passenger_compile":
    command  => "/usr/local/lib/ruby/gems/1.8/gems/passenger-3.0.14/bin/passenger-install-apache2-module -a",
    timeout  => 1000000,
#    path     => "/bin/:/usr/bin/",
    }


file {"/etc/httpd/conf.d/passenger.conf":
    owner => "root",
    group => "root",
    mode => 0655,
    source    => 'puppet:///modules/passenger-apache/etc/httpd/conf.d/passenger.conf',
    require => Package["httpd"],
    }

#package { 'rake':
#    ensure   => 'installed',
#    provider => 'gem',
#    require  => Package["rubygems"],
#}

#package { 'rails':
#    ensure   => 'installed',
#    provider => 'gem',
#    require  => Package["rubygems"],
#}

#package { 'passenger':
#    ensure   => 'installed',
#    provider => 'gem',
#    require  => Package["rubygems"],
#}

}

