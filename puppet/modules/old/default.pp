

class {'wetty': }
class {'cloudcommander': }

class { 'pimpmylog':
  require => [Package['apache'], Package['mysql-server']]
}

class { 'hhvm':
  manage_repos => true,
  pgsql        => false
}

class { 'varnish': }

class { 'zray':
  notify  => Service['apache'],
  require => Class['php']
}