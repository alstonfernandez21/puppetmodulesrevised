define nginx::vhost (
  $host = '',
  $port = '80',
  $listen = '*',
  $ssl_offload = 'false',
  $ssl = 'false',
  $ssl_cert = '',
  $ssl_cert_key = '',
  $technology = '',
  $ssl_rewrite_all = '',
  $server_append = 'UNSET',
  $php_append = 'UNSET',
  $append = '',
  $location_append= 'UNSET',
  $aliases = [],
  $upstreams=[],
  $rvm_ruby_version = 'ruby-1.9.2-p290',
  $rails_version   = '3.2.8',
  $rails_app_path = '',
  $passenger_version = '',
  $passenger_max_pool_size = '',
  $passenger_max_instances = '',
  $passenger_pre_start = '',
  $passenger_use_global_queue = 'on',
  $passenger_enabled	= 'on',
  $rails_env	= 'UNSET') {

  include nginx


  file {"/etc/nginx/conf.d/${host}.conf":
        owner   => "root",
        group   => "root",
        mode    => 0770,
        content => template("nginx/vhost.conf.erb"),
        notify => Service["nginx"],
  	require    => Package["nginx"],

  }


  file {"/data/web/${host}":
        ensure  => "directory",
        owner   => "root",
        group   => "root",
        mode    => 0765,
        require    => Package["nginx"],
  }

 #if $technology == 'rails' {
 #	include passenger-nginx
 # }
 
 if $ssl == true {
    file {
	"/data/ssl/${host}.crt":	
	content => "${ssl_cert}";
        "/data/ssl/${host}.key": 
	content => "${ssl_cert_key}",
	mode => 600;
	}
	
 }

 if $technology == 'rails' {
	rvm_system_ruby {
  		"${rvm_ruby_version}":
    		ensure		=> 'present',
    		default_use 	=> true,

	}
	rvm_gem {
  		'passenger':
    		name => 'passenger',
    		ruby_version => "${rvm_ruby_version}",
    		ensure => latest,
    		require => Rvm_system_ruby["${rvm_ruby_version}"];
		}

	file { "/opt/compilepassenger.sh" :
        	  ensure => present,
	      	  mode => 0755,
          	  owner => "root",
          	  group => "root",
    	  	  content => template("nginx/compilepassenger.erb"),
		  require => Rvm_gem["passenger"],
  	}
	
	exec { "compile_rvm":
    		  command  => "/bin/sh /opt/compilepassenger.sh",
    		  timeout  => 100000,
    		  path     => "/bin/:/usr/bin/",
    		  require  => File["/opt/compilepassenger.sh"],
		  subscribe => File["/opt/compilepassenger.sh"],
		  refreshonly => true,
		  before => File["/etc/nginx/conf.d/passenger.conf"],
    	}
	
	file { "/etc/nginx/conf.d/passenger.conf" :
                  ensure => present,
                  mode => 0770,
                  owner => "root",
                  group => "root",
                  content => template("nginx/passenger.erb"),
		  notify => Service["nginx"],

        }

	package {'nginx-passenger':
                ensure   => 'installed',
                provider => 'yum',
		before => [ File["/etc/nginx/conf.d/passenger.conf",
				 "/opt/compilepassenger.sh"],
			    Exec["compile_rvm"], 
			    Rvm_gem["passenger"],				    	
					],
        }


}

 if $technology == 'php' {
 	include php-nginx
 }
  
}

