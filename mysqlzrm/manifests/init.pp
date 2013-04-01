class mysql-zrm (
		$backup_level = '0',
                $backup_mode  = 'logical',
                $backup_type  = 'regular',
                $destination  = '/data/backup/mysql',
                $retention    = "",
                $compress     = '1',
                $databases    = [],
                $user         = "",
                $password     = "",
                $host         = "localhost",
                $mailto       = "alston.fernandez@gmail.com",
		){

 file {"/etc/mysql-zrm/mysql-zrm.conf":
        owner   => "root",
        group   => "root",
        mode    => "0600",
        content => template("mysqlzrm/mysql-zrm.conf.erb"),
        require => Package["MySQL-zrm"],
 }

 package { "MySQL-zrm":
        ensure => 'installed',
        provider => 'yum',
 }

}
