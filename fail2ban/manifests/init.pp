class fail2ban {

package { "fail2ban":
	before 	=> [	File["/etc/fail2ban/filter.d/sshd.conf"], 
			File["/etc/fail2ban/jail.local"],],
        }


file { "/etc/fail2ban/filter.d/sshd.conf":
        mode    => "0750",
        owner   => "root",
        group   => "root",
        source  => 'puppet:///modules/fail2ban/sshd.conf',
        }


file { "/etc/fail2ban/jail.local":
        mode    => "0750",
        owner   => "root",
        group   => "root",
        source  => 'puppet:///modules/fail2ban/jail.local',
	before  => File["/etc/fail2ban/filter.d/sshd.conf"],
	notify => Service["fail2ban"],
        }

include fail2ban::service


}
