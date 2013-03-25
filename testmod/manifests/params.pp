class test::params {

case $operatingsystem {
 Solaris: {
	$osversion = 'Solaris'
 	}
 /(Ubuntu|Debian)/: { 
 	$osversion = 'Debian or Ubuntu'
	 } 
/(RedHat|CentOS|Fedora)/: {
	$osversion = 'Redhat or CentOS or Fedora' 
 	}
 }

notice("This client is using the $osversion")
}
