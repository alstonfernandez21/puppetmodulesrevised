class rabbitmq (
		$key = "http://www.rabbitmq.com/rabbitmq-signing-key-public.asc",
		$version = "2.7.1",
		$relversion = "1",
		) {
		

	file {"/etc/yum.repos.d/epel-erlang.repo":
		ensure	=> "present",
		owner	=> "root",
		group	=> "root",
		mode	=> "0644",
		source	=> 'puppet:///modules/rabbitmq/epel-erlang.repo',
	}

	package {'erlang':
		ensure	=> 'installed',
		provider => 'yum',
		require  => File["/etc/yum.repos.d/epel-erlang.repo"],
	}

	exec { "rpm --import ${key}":
		path => ["/bin","/usr/bin","/sbin","/usr/sbin"],
		before => Package["rabbitmq-server"],		
	}
	package { "rabbitmq-server":
	        provider => 'rpm',
 	        ensure => installed,
        	source => "http://www.rabbitmq.com/releases/rabbitmq-server/v${version}/rabbitmq-server-${version}-${relversion}.noarch.rpm",
        	require => Exec["rpm --import ${key}"],
    	}	






include rabbitmq::service
include rabbitmq::server
}
