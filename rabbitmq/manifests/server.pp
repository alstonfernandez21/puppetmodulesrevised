class rabbitmq::server (
			$port = '5672',
			$delete_guest_user = false,
  			$package_name = 'rabbitmq-server',
  			$version = 'UNSET',
  			$service_name = 'rabbitmq-server',
  			$service_ensure = 'running',
  			$config_stomp = false,
 		        $stomp_port = '6163',
  			$config_cluster = false,
  			$cluster_disk_nodes = [],
  			$node_ip_address = 'UNSET',
  			$config='UNSET',
  			$env_config='UNSET',
  			$erlang_cookie='EOKOWXQREETZSHFNTPEY',
  			$wipe_db_on_cookie_change=false
	) {

  if $version == 'UNSET' {
    $version_real = '2.7.1'
  } else {
    $version_real = $version
  }
  if $config == 'UNSET' {
    $config_real = template("rabbitmq/rabbitmq.config.erb")
  } else {
    $config_real = $config
  }
  if $env_config == 'UNSET' {
    $env_config_real = template("rabbitmq/rabbitmq-env.conf.erb")
  } else {
    $env_config_real = $env_config
  }

  $plugin_dir = "/usr/lib/rabbitmq/lib/rabbitmq_server-${version_real}/plugins"


  file { '/etc/rabbitmq':
    ensure  => directory,
    owner   => '0',
    group   => '0',
    mode    => '0644',
    require => Package[$package_name],
  }

  file { 'rabbitmq.config':
    ensure  => file,
    path    => '/etc/rabbitmq/rabbitmq.config',
    content => $config_real,
    owner   => '0',
    group   => '0',
    mode    => '0644',
    require => Package[$package_name],
    notify  => Class['rabbitmq::service'],
  }

  if $config_cluster {
    file { 'erlang_cookie':
      path =>"/var/lib/rabbitmq/.erlang.cookie",
      owner   => rabbitmq,
      group   => rabbitmq,
      mode    => '0400',
      content => $erlang_cookie,
      replace => true,
      before  => File['rabbitmq.config'],
      require => Exec['wipe_db'],
    }
    # require authorize_cookie_change

    if $wipe_db_on_cookie_change {
      exec { 'wipe_db':
        command => '/etc/init.d/rabbitmq-server stop; /bin/rm -rf /var/lib/rabbitmq/mnesia',
        require => Package[$package_name],
        unless  => "/bin/grep -qx ${erlang_cookie} /var/lib/rabbitmq/.erlang.cookie"
      }
    } else {
      exec { 'wipe_db':
        command => '/bin/false "Cookie must be changed but wipe_db is false"', # If the cookie doesn't match, just fail.
        require => Package[$package_name],
        unless  => "/bin/grep -qx ${erlang_cookie} /var/lib/rabbitmq/.erlang.cookie"
      }
    }
  }

  file { 'rabbitmq-env.config':
    ensure  => file,
    path    => '/etc/rabbitmq/rabbitmq-env.conf',
    content => $env_config_real,
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['rabbitmq::service'],
  }

}
