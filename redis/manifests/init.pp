class redis (
	$port = '6379',
	$bind = '127.0.0.1',
	$rtimeout = '200',
	$rloglevel = 'notice',
	$logfile = 'redis.log',
	$databases = '16',
	$dbfilename = 'dump.rdb',
	$appendfilename = 'UNSET',
	$syslog_enabled	= 'UNSET',
	$syslog_indent = 'UNSET',
	$syslog_facility = 'UNSET',
	$slaveof = 'UNSET',
	$masterauth = 'UNSET',
	$repl_ping_slave_period = 'UNSET',
	$repl_timeout = 'UNSET',
	$requirepass = 'UNSET',
	$maxclients = 'UNSET',
	$maxmemory = 'UNSET',
	$maxmemory_policy = 'UNSET',
	$maxmemory_samples = 'UNSET',
	$stop_writes_on_bgsave_error = 'UNSET',
	$rdbchecksum = 'UNSET',
	$slave_serve_stale_data = 'UNSET', 
	$slave_read_only = 'UNSET',
	$lua_time_limit = 'UNSET',
	$client_output_buffer_limit = [], 
	$rdbcompression = 'yes',
	$dir 		= '/data/redis/',
	$appendonly 	= 'no',
	$appendfsync 	= 'everysec',
	$no_appendfsync_on_rewrite 	= 'no', 
	$auto_aof_rewrite_percentage	= '100',
	$auto_aof_rewrite_min_size	= '64mb',
	$slowlog_log_slower_than	= '10000',
	$slowlog_max_len	= '1024',
	$vm_enabled		= 'no',
	$vm_swap_file 		= '/tmp/redis.swap',
	$vm_max_memory 		= '0',
	$vm_page_size		= '32',
	$vm_pages		= '134217728',
	$vm_max_threads		= '4',
	$hash_max_zipmap_entries = '512',
	$hash_max_zipmap_value 	= '64',
	$list_max_ziplist_entries = '512',
	$list_max_ziplist_value = '64',
	$set_max_intset_entries = '512',
	$zset_max_ziplist_entries = '128',
	$zset_max_ziplist_value = '64',
	$activerehashing = 'yes',
	) {
 	 package {
        	"redis": ensure => present;
         }
	 
	 file { "/data/redis":
 	   ensure => "directory",
    	   owner  => "redis",
    	   group  => "redis",
    	   mode   => 0770,
	   require => Package[redis],
	 }

	 file { "/data/log/redis":
           ensure => "directory",
           owner  => "redis",
           group  => "root",
           mode   => 750,
           require => Package[redis],
         }


	 file { "/etc/redis.conf":
            mode    => "750",
            owner => "root",
            group => "redis",
            content => template("redis/redis.conf.erb"),
            notify => Service[redis],
	    require => Package[redis],
         }

 	 service { "redis":
        	enable => true,
        	ensure  => running,
        	hasstatus       => true,
        	hasrestart      => true,
        	require => Package[redis],
     	 }


}
