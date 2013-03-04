class apache {
	package {'httpd':
	ensure => 'installed',
	provider => 'yum',
	}
	package {'httpd-devel':
        ensure => 'installed',
        provider => 'yum',
        }
	package {'mod_ssl':
        ensure => 'installed',
        provider => 'yum',
        }

file { "/etc/httpd/conf/httpd.conf":
        mode    => "644",
        owner   => "root",
        group   => "root",
        source  => 'puppet:///modules/apache/httpd.conf',
        require  => Package["httpd"],
        }

	
include apache::service
}

