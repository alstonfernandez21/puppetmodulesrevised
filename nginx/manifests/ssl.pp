define nginx::ssl (
$host = '',
$technology = '',
$port = '443',
$ssl = 'true',
$serveraliases = "www.${host}",
$certfile,
$certkeyfile) {

include nginx

file {"/etc/nginx/conf.d/${host}.conf":
        owner   => "root",
        group   => "root",
        mode    => 0654,
        content => template("nginx/vhost_ssl.erb"),
        notify => Service["nginx"],
        }

file {"/data/web/${host}":
        ensure  => "directory",
        owner   => "root",
        group   => "root",
        mode    => 0775,
        }

if $technology == 'rails' {
 	include passenger-nginx
 }

if $technology == 'php' {
 	include php-nginx

  }


}
