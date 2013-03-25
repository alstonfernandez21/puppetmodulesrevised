class php-nginx {
	       $php_packages = [ "php53", "php53-cli", "php53-common", "php53-gd", "php53-xml", "php53-mbstring", "php53-mcrypt", "php53-pdo", "php53-devel",  ]
        package { $php_packages:
                before => Package["spawn-fcgi"],
        }
        package { "php53-mysql":
            #    require => Package["mysql"],
        }


        package { "spawn-fcgi":
                ensure => "installed",
                require => Package["php53"],
                before => File["/etc/init.d/php_cgi"],
        }

        file {"/etc/init.d/php_cgi":
                ensure  => "present",
                owner   => "root",
                group   => "root",
                mode    => 0755,
                source    => 'puppet:///modules/nginx/etc/init.d/php_cgi',
                require => Package["spawn-fcgi"],
                before  => Service["php_cgi"],
        }

        #service { "php_cgi":
        #        ensure    => 'running',
        #        require   => Package["spawn-fcgi"],
	#	hasstatus => false,
        #}

	include php-nginx::service 
}
