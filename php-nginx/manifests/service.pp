class php-nginx::service {
        service { 'php_cgi':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => Package["spawn-fcgi"],
        }
}
