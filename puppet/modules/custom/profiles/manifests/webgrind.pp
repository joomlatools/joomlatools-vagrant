class profiles::webgrind {

  package { 'graphviz':
    ensure => installed
  }

  file { '/usr/share/webgrind':
    ensure => directory,
    owner  => vagrant,
    group  => vagrant
  }

  exec { 'install-webgrind':
    command => 'composer create-project jokkedk/webgrind:^1.5.0 /usr/share/webgrind --no-interaction',
    cwd     => '/usr/share/webgrind',
    unless  => 'test -d /usr/share/webgrind/vendor',
    path    => ['/usr/local/bin', '/usr/bin'],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer',
    require => [File['/usr/share/webgrind'], Anchor['php::end']]
  }

  file { '/usr/share/webgrind/config.php':
    ensure => file,
    owner  => vagrant,
    group  => vagrant,
    source => 'puppet:///modules/profiles/webgrind/config.php',
    require => Exec['install-webgrind']
  }
  ->
  file { '/usr/share/webgrind/bin':
    ensure => directory,
    owner  => www-data,
    group  => www-data
  }

  apache::vhost { 'webgrind':
    server_name   => 'webgrind',
    serveraliases => 'webgrind.joomla.box',
    docroot       => '/usr/share/webgrind',
    port          => 80,
    priority      => 10
  }

}