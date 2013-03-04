hostclass :packages, :arguments => {"name" => nil} do
 package [scope.lookupvar("name")], :ensure => 'present'
end
