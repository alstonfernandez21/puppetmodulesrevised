class php53 {
$php_packages = [ "php53", "php53-cli", "php53-common", "php53-gd", "php53-xml", "php53-mbstring", "php53-mcrypt", "php53-pdo", "php53-devel", ]
package { $php_packages: }
package { "php53-mysql":
	  #require => Package["mysql-server"],
	}

file { "/etc/php.ini":
	notify => Service["httpd"],
	mode   => 0644,
	owner  => "root",
	group  => "root",
	require => Package["php53"],
}



}
