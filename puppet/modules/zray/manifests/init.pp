class zray {

  archive { 'zray-php-101832-php5.6.11':
    ensure           => present,
    url              => 'http://repos.zend.com/zend-server/early-access/zray-tech-preview/zray-php-101832-php5.6.11-linux-debian7-amd64.tar.gz',
    target           => '/opt',
    root_dir         => 'zray',
    checksum         => false,
    strip_components => 1
  }
  ->
  exec {'zray-chown-www-data':
    command => '/usr/bin/find /opt/zray ! -user www-data -exec /bin/chown www-data:www-data {} \;'
  }

  file { '/etc/apache2/sites-available/00-zray.conf':
    ensure  => present,
    source  => '/opt/zray/zray-ui.conf',
    require => Archive['zray-php-101832-php5.6.11']
  }
  ->
  file { '/etc/apache2/sites-enabled/00-zray.conf':
    ensure => link,
    target => '/etc/apache2/sites-available/00-zray.conf'
  }

  file { '/usr/lib/php5/20131226/zray.so':
    ensure  => link,
    target  => '/opt/zray/lib/zray.so',
    require => Archive['zray-php-101832-php5.6.11']
  }
  ->
  file { ['/etc/php5/apache2/conf.d/zray.ini', '/etc/php5/cli/conf.d/zray.ini']:
    ensure => link,
    target => "/opt/zray/zray.ini"
  }

}