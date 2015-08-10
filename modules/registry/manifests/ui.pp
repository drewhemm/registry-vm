class registry::ui (
	$context,
	$data_dir,
	$host_port
) {
	file { $data_dir:
		ensure => directory,
	}

	docker::image {'atcol/docker-registry-ui':
	} ->

	docker::run {'registry-ui':
		image => 'atcol/docker-registry-ui',
		ports => ["${host_port}:8080"],
		expose => ['8080'],
		restart_service => true,
		pull_on_start   => true,
		dns => ['8.8.8.8', '8.8.4.4'],
		require => [Class['docker'], Docker::Run['registry'], File[$data_dir]],
		# Disable data persistence until the h2 bug is resolved
		# volumes => [
		# 	["${ui_data_dir}:/var/lib/h2"]
		# ],
		env => ["APP_CONTEXT=${context}", 'REG1=http://172.17.42.1:5000/v1/'],
		depends => ['registry'],
	}	
}