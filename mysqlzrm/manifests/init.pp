class mysql-zrm {
	package { "MySQL-zrm":
        ensure => 'installed',
        provider => 'yum',
	}
}
