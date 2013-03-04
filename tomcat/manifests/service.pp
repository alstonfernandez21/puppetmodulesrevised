class tomcat::service {
        service { 'tomcat6':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => Package["tomcat6"],
        }
}

