define apache::vhost( 
 $host = '',
 $port = '80',
 $proxy = 'false',
 $listen = '*',
 $serveradmin = "admin@${host}",
 $override = 'All',
 $ssl = 'false',
 $ssl_cert = '',
 $ssl_cert_key = '',
 $technology = '',
 $ssl_rewrite_all = '',
 $aliases = [],
 $dest = '',
 $directory_index = '',
 $dont_proxy = [],
 $append = '') {

 include apache

 file {"/etc/httpd/conf.d/${host}.conf":
       owner   => "root",
       group   => "root",
       mode    => 0770,
       content => template("apache/vhost.conf.erb"),
       notify  => Service["httpd"],
       require => Package["httpd"],
 }

 file {"/data/web/${host}":
        ensure  => "directory",
        owner   => "${host}",
        group   => "${host}",
        mode    => 0751,
        require    => Package["httpd"],
	before 	=> File["/home/${host}"],
  }
#ADDS A SFTP USER WITH THE DOMAIN NAME before the /data/web/${domain} folder is created
 user { "${host}":
      	ensure 	=> "present",
      	comment => "FTP User",
      	home 	=> "/home/${host}",
     	shell 	=> "/bin/bash",
      	managehome => true,
	before	=> File["/data/web/${host}"],

}
#CREATE HOME FOLDER FOR SSH OR SFTP USER AFTER user is added
 file { "/home/${host}":
      	mode => 700,
      	require => User["${host}"],
 }

#######################################
 file { "/home/${host}/webroot":
        ensure => link,
        target => "/data/web/${host}",
        require => User["${host}"]
 }



 if $ssl == true {
    file {
        "/data/ssl/${host}.crt":
        content => "${ssl_cert}";
        "/data/ssl/${host}.key":
        content => "${ssl_cert_key}",
        mode => 600,

        }
 }

 if $technology == 'php' {
	include php53
 }

}

