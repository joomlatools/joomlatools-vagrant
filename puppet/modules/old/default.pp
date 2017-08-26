

class {'wetty': }
class {'cloudcommander': }

class { 'pimpmylog':
  require => [Package['apache'], Package['mysql-server']]
}

class { 'varnish': }

class { 'zray':
  notify  => Service['apache'],
  require => Class['php']
}