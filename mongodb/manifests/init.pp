class mongodb (
	$port = '27017',
	$bind_ip = 'UNSET',
	$logappend = 'true',
	$quiet 	 = 'true',
	$auth 	= 'true',
	$dbpath = '/data/mongodb',
	$mongodblogpath = 'mongodb.log',
	$replset	= 'UNSET',
	$keyfile = '/data/mongodb/mongodbkey',
	) {

file { "/etc/yum.repos.d/10gen-mongodb.repo":
	mode    => "644",
        owner 	=> "root",
        group 	=> "root",
	source 	=> 'puppet:///modules/mongodb/etc/yum.repos.d/10gen-mongodb.repo',
	before  => Package["mongo-10gen-server"],
        }

file { "/data/mongodb/mongodbkey":
	mode  => "0600",
	owner => "mongod",
	group => "mongod",
	replace => false,
	source  => 'puppet:///modules/mongodb/data/ssl/mongodbkey',
	require => File["/data/mongodb"],
	}

 $mongodb_packages = [ "mongo-10gen", "mongo-10gen-server", ]
	package { $mongodb_packages: 
	require => File["/etc/yum.repos.d/10gen-mongodb.repo"],
	}
   
file { "/data/mongodb":
	ensure => "directory",
        owner  => "mongod",
        group  => "mongod",
        mode   => "750",
        require => Package["mongo-10gen-server"],
        }

file { "/data/log/mongodb":
        ensure => "directory",
        owner  => "mongod",
        group  => "mongod",
        mode   => "750",
        require => Package["mongo-10gen-server"],
        }

file { "/etc/mongod.conf":
	mode    => "754",
        owner 	=> "root",
        group 	=> "root",
	content => template("mongodb/mongod.conf.erb"),
	require  => Package["mongo-10gen-server"],
	notify => Service[mongod],
	}

file { "/etc/init.d/mongod":
        mode    => "0755",
        owner   => "root",
        group   => "root",
        source  => 'puppet:///modules/mongodb/etc/init.d/mongod',
        require  => Package["mongo-10gen-server"],
        }


file { "/opt/mongosback.sh":
        mode  => "0755",
        owner => "root",
        group => "root",
        replace => false,
        source  => 'puppet:///modules/mongodb/mongosback/mongosback.sh',
        }

file { "/opt/mongosback.conf":
        mode  => "0700",
        owner => "root",
        group => "root",
        replace => false,
        source  => 'puppet:///modules/mongodb/mongosback/mongosback.conf',
        }


 service { "mongod":
        enable => true,
        ensure  => running,
        hasstatus       => true,
        hasrestart      => true,
        require => Package["mongo-10gen-server"]
    	}
}
