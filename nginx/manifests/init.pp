class nginx {
        file {"/etc/yum.repos.d/passenger.repo":
	        ensure  => "present",
		owner   => "root",
	        group   => "root",
	        mode    => 0644,
	        source    => 'puppet:///modules/nginx/etc/yum.repos.d/passenger.repo',
	}


	package {'nginx':
		ensure 	 => 'installed',
		provider => 'yum',
	}
include nginx::service
}
