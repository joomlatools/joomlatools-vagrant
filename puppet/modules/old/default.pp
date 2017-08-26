

apache::vhost { 'joomla.box':
  server_admin  => 'webmaster@localhost',
  serveraliases => 'localhost',
  port          => 8080,
  priority      => '00',
  docroot       => '/var/www',
  directory     => '/var/www',
  directory_allow_override   => 'All',
  directory_options => 'Indexes FollowSymLinks MultiViews',
  template     => 'apache/vi rtualhost/joomlatools.vhost.conf.erb',
}

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