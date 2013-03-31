hostclass :redisbackup, :arguments => {"backupdir" => AST::String.new(:value => "/data/redis"),
				       "backupto" => AST::String.new(:value => "/data/backup/redis"),
				       "scriptpath" => AST::String.new(:value => "/opt/redis_backup.sh")} do



	file [scope.lookupvar("scriptpath")],
	:mode	=> '0700',
	:owner 	=> 'root',
	:group  => 'root',
	:source => 'puppet:///modules/redis-backup/opt/redis_backup.sh'
end
