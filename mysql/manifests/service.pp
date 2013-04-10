class mysql::service {
	 service { "mysqld":
	 ensure     => running,
         hasstatus  => true,
         hasrestart => true,
         enable     => true,
         require    => Package["mysql-server"],
	 before => Exec["set-mysql-password"],

         }
}
