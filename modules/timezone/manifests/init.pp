class timezone($timezone = 'Europe/London') {
	case $operatingsystem {
		/^(Debian|Ubuntu)$/: {
			file { '/etc/timezone':
				ensure => present,
				content => template('timezone/timezone.erb'),
				notify => Exec['reload-tzdata'],
			}

			exec { 'reload-tzdata':
				command      => 'dpkg-reconfigure --frontend noninteractive tzdata',
				refreshonly  => true,
			}
		}
	}	
}