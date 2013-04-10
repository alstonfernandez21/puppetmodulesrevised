define mysql::db ( $name, $user, $password, $grant = 'ALL ON', $host = '127.0.0.1' ) {
      exec { "create-${name}-db":
      	unless => "/usr/bin/mysql -h ${host} -uroot  ${name}",
       	command => "/usr/bin/mysql -uroot -e \"create database ${name}; grant ${grant} ON ${name}.* to '${user}'@'${host}' identified by '';update mysql.user set Password = '$password' WHERE User = '${user}'; flush privileges;\"",
	require => Package["mysql-server"],
#command => "/usr/bin/mysql -uroot -p$mysql_password -e \"create database ${name}; grant ${grant} ON ${name}.* to '${user}'@'${host}' identified by '$password';\"",
    }
  }
