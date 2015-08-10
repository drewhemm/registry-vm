class registry::jenkins (
	$data_dir,
	$prefix
) {

	docker::image {'jenkins':
	} ->

	docker::run { 'jenkins':
		image => 'jenkins',
		ports => ['8080:8080'],
		expose => ['8080'],
		restart_service => true,
		pull_on_start   => true,
		dns => ['8.8.8.8', '8.8.4.4'],
		require => [Class['docker']],
		volumes => [
			["${data_dir}"]
		],
		env => [
			"JENKINS_OPTS=--prefix=/${prefix}",
		]
	}
}