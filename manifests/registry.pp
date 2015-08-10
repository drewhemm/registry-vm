Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin" }

$accounts = hiera_hash('accounts', {})

include timezone

include registry