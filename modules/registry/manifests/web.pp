class registry::web (
	$apache_user = 'www-data',
	$apache_group = 'www-data',
	$apache_docroot,
	$ui_context,
	$ui_host_port,
	$jenkins_prefix,
) {

	class { 'apache':
		purge_configs => true,
		default_vhost => false,
		confd_dir => '/etc/apache2/conf-enabled',
		default_confd_files => false,
		mpm_module => 'prefork',
	}

	include apache::mod::proxy, apache::mod::proxy_http

	file { $apache_docroot:
		ensure => directory,
		owner => $apache_user,
		group => $apache_group,
	}

	apache::vhost {$::fqdn:
		port => 80,
		docroot => $apache_docroot,
		allow_encoded_slashes => 'nodecode',
		proxy_preserve_host => true,
		proxy_pass => [
			{ 'path' => "/${jenkins_prefix}", 'url' => "http://localhost:8080/${jenkins_prefix}/"},
			{ 'path' => "/${ui_context}", 'url' => "http://localhost:${ui_host_port}/${ui_context}"},
			{ 'path' => '/', 'url' => 'http://localhost:5000/'}
		],
		require => File[$apache_docroot],
	}
}