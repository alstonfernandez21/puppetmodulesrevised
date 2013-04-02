require 'fileutils'

Puppet::Type.type(:mysqlzrm).provide(:mysqlzrmscheduler) do

	desc "Provides MySQL ZRM scheduler support for puppet"
	desc "mysql-zrm-scheduler --add --interval daily --backup-set dailyrun --start 13:35 --backup-level 0	"

	
	commands :mysqlzrmsched => "mysql-zrm-scheduler"
	
	def create
	 mysqlzrmsched "--add", "--interval", resource[:interval], "--backup-set", resource[:backupset], "--start", resource[:time], "--backup-level", resource[:backuplevel] 
	end

	def destroy
     mysqlzrmsched "--delete", "--interval", resource[:interval], "--backup-set", resource[:backupset], "--start", resource[:time], "--backup-level", resource[:backuplevel] 
	end

	def exists?
	 mysqlzrmsched "--add", "--interval", resource[:interval], "--backup-set", resource[:backupset], "--start", resource[:time], "--backup-level", resource[:backuplevel] 
	end
end
