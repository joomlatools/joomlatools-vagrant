class zray {

  archive { 'zray-php-101832-php5.6.11':
    ensure           => present,
    url              => 'http://repos.zend.com/zend-server/early-access/zray-tech-preview/zray-php-101832-php5.6.11-linux-debian7-amd64.tar.gz',
    target           => '/opt',
    checksum         => false
  }
  ->
  exec {'zray-chown-www-data':
    command => '/usr/bin/find /opt/zray-php-101832-php5.6.11-linux-debian7-amd64 ! -user www-data -exec /bin/chown www-data:www-data {} \;'
  }
  ->
  zray::apache::vhost { 'zray-php5.6':
    ensure  => present,
    path    => '/opt/zray-php-101832-php5.6.11-linux-debian7-amd64/zray',
    enable  => true
  }
  ->
  zray::php::ini { 'zray-php5.6':
    ensure  => present,
    path    => '/opt/zray-php-101832-php5.6.11-linux-debian7-amd64/zray',
    enable  => true
  }

  archive { 'zray-php-101832-php5.5.27':
    ensure           => present,
    url              => 'http://repos.zend.com/zend-server/early-access/zray-tech-preview/zray-php-101832-php5.5.27-linux-debian7-amd64.tar.gz',
    target           => '/opt',
    checksum         => false
  }
  ->
  exec {'zray-php5.5-chown-www-data':
    command => '/usr/bin/find /opt/zray-php-101832-php5.5.27-linux-debian7-amd64 ! -user www-data -exec /bin/chown www-data:www-data {} \;'
  }
  ->
  zray::apache::vhost { 'zray-php5.5':
    ensure  => present,
    path    => '/opt/zray-php-101832-php5.5.27-linux-debian7-amd64/zray'
  }
  ->
  zray::php::ini { 'zray-php5.5':
    ensure  => present,
    path    => '/opt/zray-php-101832-php5.5.27-linux-debian7-amd64/zray'
  }

}