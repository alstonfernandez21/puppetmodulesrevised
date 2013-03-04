class tomcat::config (
	$tomcat6_packages = [ "tomcat6", "tomcat6-webapps", "tomcat6-admin-webapps", "java-1.6.0-openjdk", "java-1.6.0-openjdk-devel", ],
	$tomcat_user = "tomcat",
	$jdk_version = "",
	$java_home = "/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/bin",
	$catalina_base = "/usr/share/tomcat6",
	$catalina_home = "/usr/share/tomcat6",
	$java_opts = "UNSET",

	) {

	file { "/usr/share/tomcat6/conf/tomcat6.conf":
		ensure => present,
                mode => 0644,
                owner => "root",
                group => "root",
                content => template("tomcat/tomcat6.conf.erb"),
                notify => Service["tomcat6"],
		require => Package[$tomcat6_packages],
        }



			
}
