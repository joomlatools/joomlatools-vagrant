class profiles::webgrind {

  package { 'graphviz':
    ensure => installed
  }

  archive { '/tmp/webgrind-1.2.tar.gz':
    ensure           => present,
    source           => 'https://github.com/alpha0010/webgrind/archive/1.2.tar.gz',
    extract          => true,
    extract_path     => '/usr/share',
    checksum         => 'c725c3815f0d7d867bbe29aa3c4461148b720e58',
    checksum_type    => 'sha1',
    cleanup          => true,
    creates          => '/usr/share/webgrind-1.2',
  }
  ->
  file { '/usr/share/webgrind-1.2/config.php':
    ensure => file,
    source => 'puppet:///modules/profiles/webgrind/config.php'
  }

  apache::vhost { 'webgrind':
    server_name   => 'webgrind',
    serveraliases => 'webgrind.joomla.box',
    docroot       => '/usr/share/webgrind-1.2',
    port          => 80,
    priority      => '10'
  }

}