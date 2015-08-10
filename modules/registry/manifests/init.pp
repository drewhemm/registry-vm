class registry (
	$docker_user = 'vagrant',
	$data_dir = '/var/lib/registry',
	$jenkins_prefix = 'jenkins',
	$ui_context = 'ui',
	$ui_port = 8081
) {

	class { 'apt': }

	package { 'language-pack-en':
		ensure => present,
	}
	
	class { 'docker':
		docker_users => [$docker_user],
		extra_parameters => ["--iptables=false"],
	}

	# file { '/etc/docker/certs.d/registry.crt':
	# 	ensure => file,
	# 	source => 'puppet:///modules/registry/registry.crt',
	# }

	# file { '/etc/docker/certs.d/registry.key':
	# 	ensure => file,
	# 	content => hiera('registry::ssl::key'),
	# 	mode => 0600,
	# }

	file { [$data_dir]:
		ensure => directory,
	}

	docker::image {'registry':
	} ->

	docker::run { 'registry':
		image => 'registry',
		ports => ['5000:5000'],
		expose => ['5000'],
		restart_service => true,
		pull_on_start   => true,
		dns => ['8.8.8.8', '8.8.4.4'],
		require => [Class['docker'], File[$data_dir]],
		volumes => [
			# ['/etc/docker/certs.d:/certs'], 
			["${data_dir}:${data_dir}"]
		],
		env => [
			# We'll run the registry in http and protect it with SSL at the Apache proxy
			# 'REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt',
			# 'REGISTRY_HTTP_TLS_KEY=/certs/registry.key',
			"REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=${data_dir}",
		],
	}

	# Web browser interface to the Docker registry
	class {'::registry::ui':
		context => $ui_context,
		data_dir => '/var/lib/registry_ui',
		host_port => $ui_port,
	}

	# Apt-cacher-ng, to reduce network traffic when building the Docker images
	class { 'aptcacherng':
	}

	# Jenkins
	class { '::registry::jenkins':
		data_dir => '/var/jenkins_home',
		prefix => $jenkins_prefix,
	}

	# Apache web server
	class { '::registry::web':
		apache_docroot => '/var/www/registry',
		jenkins_prefix => $jenkins_prefix,
		ui_context => $ui_context,
		ui_host_port => $ui_port,
	}
}