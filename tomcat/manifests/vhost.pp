define tomcat::vhost (
	$host = "",
        $aliases = [],
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

	file {"/usr/share/tomcat6/webapps/${host}":	
		ensure  => "directory",
        	owner   => "root",
        	group   => "root",
        	mode    => 0755,
		require    => Package["tomcat6"],
	}
		
	file {"/usr/share/tomcat6/conf/${host}.txt":
        	owner   => "root",
        	group   => "root",
        	mode    => 0654,
        	content => template("tomcat/vhost.txt.erb"),
        	notify => Service["tomcat6"],
        	require    => Package["tomcat6"],

  	}


}
