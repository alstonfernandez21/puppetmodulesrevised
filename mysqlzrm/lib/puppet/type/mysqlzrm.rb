Puppet::Type.newtype(:mysqlzrm) do
	@doc = "MySQL ZRM backup Manager"
	ensurable

	newparam(:interval) do
	 desc "The Interval to take DB Backups specified in mysql-zrm.conf"
	 
	validate do |value|
		if value =~ /^[a-z]+/ 
	 		resource[:provider] = :mysqlzrmscheduler
		else
			resource[:provider] = :mysqlzrmscheduler
		end
	end
		isnamevar
	end

	newparam(:backupset) do
		desc "Backup Set Name"

	validate do |value|
		unless value =~ /^[a-z0-9]+/
			raise AugumentError , "%s is not valid backup-set name" % value
		end
	end
    end

	newparam(:backuplevel) do
		desc "0 For Full backup | 1 For Incremental (NOTE Incremental backups need mysql-bin.log enabled) "
	
	validate do |value|
		unless value =~ /^[0-1]/
			raise AugumentError , "%d is not a valid backup level value, use either 0 or 1" % value
		end
	end
	end
	
	newparam(:time) do
		desc "Start backup at certain time"
	
	validate do |value|
		unless value =~ /^[0-9]{1,2}\:[0-9]{1,2}/
			raise AugumentError , "%s is not valid backup start time" % value
		end
	end
	end
end
