require 'fileutils'

Puppet::Type.type(:repo).provide(:svn) do
	desc "Provides Subversion support if Git not avail as well"
	
	commands :svncmd => "svn"
	commands :svnadmin => "svnadmin"

	def create 
	 svncmd "checkout", resource[:name], resource[:path]
	end

	def destroy
	 FileUtils.rm_rf resource[:path]
	end
	
	def exists?
	 File.directory? resource[:path]
	end
end
