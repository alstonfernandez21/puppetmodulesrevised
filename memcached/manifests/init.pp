class memcached (
	$port = "11211",
	$user = "memcached",
	$maxconn = "1024",
	$cachesize = "256",
	$options = ""



	) {

 package {
	"memcached": ensure => present;
       	 }
 file { "/etc/sysconfig/memcached":
            mode    => "644",
            owner => "root",
            group => "root",
            content => template("memcached/memcached.erb"),
            notify => Service[memcached],
	    require => Package[memcached],

      }
 
 service {"memcached":
        enable => true,
        ensure  => running,
        hasstatus       => true,
        hasrestart      => true,
        require => Package[memcached],
        } 


}  
