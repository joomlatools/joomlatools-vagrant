class zray {

  archive { 'zray-php-101832-php5.6.11-linux-debian7-amd64':
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

  archive { 'zray-php-101832-php5.5.27-linux-debian7-amd64':
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

  $joomla = {
    'joomla-zray-php5.5' => {
      install_directory => '/opt/zray-php-101832-php5.5.27-linux-debian7-amd64/zray/runtime/var/plugins'
    },
    'joomla-zray-php5.6' => {
      install_directory => '/opt/zray-php-101832-php5.6.11-linux-debian7-amd64/zray/runtime/var/plugins'
    }
  }

  $joomla_default = {
    archive_root_dir  => 'Z-Ray-Joomla-master',
    archive           => 'https://github.com/yireo/Z-Ray-Joomla/archive/master.zip'
  }

  create_resources('zray::plugin', $joomla, $joomla_default)

  $composer = {
    'composer-zray-php5.5' => {
      install_directory => '/opt/zray-php-101832-php5.5.27-linux-debian7-amd64/zray/runtime/var/plugins'
    },
    'composer-zray-php5.6' => {
      install_directory => '/opt/zray-php-101832-php5.6.11-linux-debian7-amd64/zray/runtime/var/plugins'
    }
  }

  $composer_default = {
    archive_root_dir  => 'Composer-master',
    archive           => 'https://github.com/zend-server-plugins/Composer/archive/master.zip'
  }

  create_resources('zray::plugin', $composer, $composer_default)


}