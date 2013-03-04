class apache::service {
	service { "httpd":
	ensure	   => running,
	hasstatus  => true,
	hasrestart => true,
	enable 	   => true,
	require	   => Package["httpd"],
	}
}
