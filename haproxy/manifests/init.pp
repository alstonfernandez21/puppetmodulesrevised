class haproxy {
	package {'haproxy':
                ensure   => 'installed',
                provider => 'yum',
        }

}
