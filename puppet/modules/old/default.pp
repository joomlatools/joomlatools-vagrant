
class { 'webgrind':
  require => Package['unzip'],
}

apache::vhost { 'webgrind':
  server_name   => 'webgrind',
  serveraliases => 'webgrind.joomla.box',
  docroot       => '/usr/share/webgrind-1.2',
  port          => 8080,
  priority      => '10',
  template      => 'apache/virtualhost/vhost-no-zray.conf.erb',
  require       => Class['webgrind']
}

apache::vhost { 'joomla.box':
  server_admin  => 'webmaster@localhost',
  serveraliases => 'localhost',
  port          => 8080,
  priority      => '00',
  docroot       => '/var/www',
  directory     => '/var/www',
  directory_allow_override   => 'All',
  directory_options => 'Indexes FollowSymLinks MultiViews',
  template     => 'apache/virtualhost/joomlatools.vhost.conf.erb',
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