Puppet::Type.newtype(:repo) do
	@doc = "Repo Management"
	ensurable
	
	newparam(:source) do
	 desc "The source repo url"

	 validate do |value|
		if value =~ /^git/
			resource[:provider] = :git
		else
			resource[:provider] = :svn
		end
	  end
		isnamevar
	end
	
	newparam(:path) do
		desc "Destination path"
	
	validate do |value|
		unless value =~ /^\/[a-z0-9]+/
			raise AugumentError , "%s is not valid repo path" % value
		end
	end
    end
end
