class webgrind {

  package { 'graphviz':
    ensure => installed
  }

  archive { 'webgrind-1.2':
    ensure           => present,
    url              => 'https://github.com/alpha0010/webgrind/archive/1.2.tar.gz',
    target           => '/usr/share',
    follow_redirects => true,
    checksum         => false
  }
  ->
  file { '/usr/share/webgrind-1.2/config.php':
    ensure => file,
    source => 'puppet:///modules/webgrind/config.php'
  }

}