class tomcat {
	
	$tomcat6_packages = [ "tomcat6", "tomcat6-webapps", "tomcat6-admin-webapps", "java-1.6.0-openjdk", "java-1.6.0-openjdk-devel", ]
	package { $tomcat6_packages: 
		before => Service["tomcat6"],
	
	}
	
	exec { "install_rpm_plone":
		command  => "rpm -Uvh http://plone.lucidsolutions.co.nz/linux/centos/images/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm",
    		timeout  => 100000,
    		path     => "/bin/:/usr/bin/",
    		before  => Package[$tomcat6_packages],
			unless => "rpm -qa | grep jpackage-utils-compat-el5-0.0.1-1",
			#refreshonly => false,

    	}

        file {"/etc/yum.repos.d/jpackage50.repo":
                ensure  => "present",
                owner   => "root",
                group   => "root",
                mode    => 0644,
                source    => 'puppet:///modules/tomcat/jpackage50.repo',
                before  => Package[$tomcat6_packages],
        }

	file {"/data/tomcat":
             ensure => link,
             target => '/usr/share/tomcat6',
             require =>  Package[$tomcat6_packages],
      	}
	
	file {"/data/log/tomcat":
             ensure => link,
             target => '/var/log/tomcat6',
             require =>  Package[$tomcat6_packages],
        }


include tomcat::config
include tomcat::service
}

