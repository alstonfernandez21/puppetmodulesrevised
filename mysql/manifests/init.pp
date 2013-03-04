class mysql 
	($bind_address = 'UNSET',
	 $default_engine = 'UNSET',
	 $server_id = 'UNSET',
	 $ssl = 'false',
	 $ssl_ca = '/data/ssl/cacert.pem',
	 $ssl_cert = '/data/ssl/server-cert.pem',	
	 $ssl_key  = '/data/ssl/server-key.pem',
	 $port   = '3306',
 	 $socket = '/var/lib/mysql/mysql.sock',
	 $user   = 'mysql',
	 $pidfile = '/var/run/mysqld/mysqld.pid',
	 $datadir = '/var/lib/mysql',
	 $log_error = '/var/log/mysqld.log',  
	 $max_connections  = 'UNSET',
	 $max_connect_errors  = 'UNSET',
	 $table_cache  = 'UNSET',
	 $max_allowed_packet  = 'UNSET',
	 $binlog_cache_size  = 'UNSET',
	 $max_heap_table_size   = 'UNSET',
	 $sort_buffer_size  = 'UNSET',
	 $join_buffer_size  = 'UNSET',
	 $thread_cache_size  = 'UNSET',
	 $thread_concurrency  = 'UNSET',
	 $query_cache_size  = 'UNSET',
	 $query_cache_limit  = 'UNSET',
	 $ft_min_word_len  = 'UNSET',
	 $default_table_type  = 'UNSET',
 	 $thread_stack  = 'UNSET',
	 $transaction_isolation  = 'UNSET',
	 $tmp_table_size  = 'UNSET',
	 $log_bin  = 'UNSET',
	 $log_bin_index = 'UNSET',
	 $log_slow_queries  = 'UNSET',
	 $long_query_time  = 'UNSET',
	 $log_long_format = 'UNSET',
	 $server_iize = 'UNSET',
	 $read_buffer_size = 'UNSET',
	 $read_rnd_buffer_size = 'UNSET',
	 $bulk_insert_buffer_size = 'UNSET',
	 $myisam_sort_buffer_size = 'UNSET',
	 $myisam_max_sort_file_size = 'UNSET',
	 $myisam_max_extra_sort_file_size = 'UNSET',
	 $myisam_repair_threads = 'UNSET',
	 $myisam_recover= 'UNSET',
	 $skip_federated = 'UNSET',
	 $skip_bdb = 'UNSET',
	 $innodb_additional_mem_pool_size = 'UNSET',
	 $innodb_buffer_pool_size = 'UNSET',
	 $innodb_data_file_path = 'UNSET',
	 $innodb_file_io_threads = 'UNSET',
	 $innodb_thread_concurrency = 'UNSET',
	 $innodb_flush_log_at_trx_commit = 'UNSET',
	 $innodb_log_buffer_size = 'UNSET',
	 $innodb_log_file_size = 'UNSET',
	 $innodb_log_files_in_group = 'UNSET',
	 $innodb_max_dirty_pages_pct = 'UNSET',
	 $innodb_lock_wait_timeout = 'UNSET',   
	 $quick = 'UNSET',
	 $max_allowed_packet = 'UNSET',
	 $no_auto_rehash = 'UNSET',
	 $key_buffer	= 'UNSET',
	 $sort_buffer_size = 'UNSET',
	 $read_buffer = 'UNSET',
	 $write_buffer = 'UNSET',
	 $interactive_timeout = 'UNSET',
	 $open_files_limit = 'UNSET',
	 $binlog_do_db = [],
	 $binlog_ignore_db = [], 
	 $auto_increment_offset = 'UNSET',
	 $auto_increment_increment = 'UNSET',
	 $master_host = 'UNSET',
	 $master_user = 'UNSET',
	 $master_password = 'UNSET',
	 $master_port = 'UNSET',
	 $master_connect_retry = 'UNSET',
	 $master_info_file = [],
	 $replicate_do_db = [],
	 $mysql_root_pw = 'myrootpassword',
	 $relay_log = [],
	 $relay_log_index = [],
	 $relay_log_info_file = [],
	 $default_charset = 'UNSET',
	) 



	{


 
#LOGIN TO ANOTHER MYSQL DATABASE AND RUN SELECT PASSWORD("YOURDESIREDROOTPASSWORD"); to get the hashed value
$password = '*86BC8DED2FD8B98E17C30C0DC4586A4277A6811A'
$mysql_packages = [ "mysql", "mysql-server" ]



package { $mysql_packages: 
	before => File[ "/data/mysql"],
	
	
}

 file { "/etc/my.cnf":
            mode    => "0600",
            owner => "root",
            group => "root",
            content => template("mysql/my.cnf.erb"),
            notify => Service["mysqld"],
            require => Package["mysql-server"],
	    before => Exec["set-mysql-password"],
       }


 file {"/data/mysql":
	     ensure => link,
	     target => '/var/lib/mysql',
	     before    => [Class["mysql::service"],Exec["set-mysql-password"],],
      }

 exec { "set-mysql-password":
	   	unless  => "/usr/bin/mysql",
    		path    => [ "/bin", "/usr/bin"],
    		command => "/usr/bin/mysql -u root -p -e \"update mysql.user set Password = '$password' WHERE User = 'root'; flush privileges;\"",
		require  => Package["mysql-server"],

       }


file { "/usr/local/sbin/mysql_backup.sh":
        mode    => "0700",
        owner   => "root",
        group   => "root",
	replace => false,
        source  => 'puppet:///modules/mysql/etc/mysql_backup.sh',
        }



include mysql::service

}
