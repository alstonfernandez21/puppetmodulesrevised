define nginx::config (
  $host = '',
  $http_append = 'UNSET',
  $server_append = 'UNSET',
  $port = '80',
  $listen = '*',
  $technology = '',
  $worker_procs = 4,
  $rlimit 	= 20000,
  $worker_conn  = 1400,
  $passenger_enabled = 'false',
  $passenger_max_pool_size = '20',
  $passenger_min_instances = '4',
  $passenger_max_instances_per_app = '0') {
  
  include nginx


  $nginx_user = $::operatingsystem ? {
   	/(?i)centos|fedora|redhat/ => "nginx",
        default                    => "nginx",
        }

  file {"/etc/nginx/nginx.conf":
                ensure => $ensure,
                owner   => "root",
                group   => "root",
                mode    => 0654,
                content => template("nginx/nginx.conf.erb"),
                require => Package["nginx"],
  		notify	=> Service ["nginx"],
  }

  
}

