define tomcat::server (
	$vhost = [],
	$listen_port = "8080",
	$timeoutconn = "20000",
	$redirectport = "8443",
	$debug = "0",
	$autodeploy = "true",
	$appbase = "webapps",
	$unpackwars = "true",
	$aliases = [],
	$prefix = "",
	$suffix = ".log",
	$timestamp = "true",
	$pattern="%h %l %u %t %r %s %b",
	$resolvehosts="false",
	$docBase="",
	$reloadable="true",
	) {

	file { "/usr/share/tomcat6/conf/server.xml":
		ensure => present,
                mode => 0644,
                owner => "root",
                group => "root",
                content => template("tomcat/server.xml.erb"),
                notify => Service["tomcat6"],
                require => Package["tomcat6"],
        }

	
}
