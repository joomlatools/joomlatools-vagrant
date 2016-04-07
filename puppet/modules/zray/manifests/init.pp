class zray {

  Archive <| title == 'zray-php5.6' or title == 'zray-php5.5' |>
    -> Zray::Plugin <| |>

  archive { 'zray-php5.6':
    ensure           => present,
    url              => 'http://repos.zend.com/zend-server/early-access/zray-tech-preview/zray-php-104202-php5.6.17-linux-debian7-amd64.tar.gz',
    target           => '/opt',
    timeout          => 600,
    checksum         => false
  }
  ->
  exec {'zray-chown-www-data':
    command => '/usr/bin/find /opt/zray-php-104202-php5.6.17-linux-debian7-amd64 ! -user www-data -exec /bin/chown www-data:www-data {} \;'
  }

  archive { 'zray-php5.5':
    ensure           => present,
    url              => 'http://repos.zend.com/zend-server/early-access/zray-tech-preview/zray-php-104202-php5.5.31-linux-debian7-amd64.tar.gz',
    target           => '/opt',
    timeout          => 600,
    checksum         => false
  }
  ->
  exec {'zray-php5.5-chown-www-data':
    command => '/usr/bin/find /opt/zray-php-104202-php5.5.31-linux-debian7-amd64 ! -user www-data -exec /bin/chown www-data:www-data {} \;'
  }

  file { '/opt/zray':
    ensure  => link,
    target  => "/opt/zray-php-104202-php5.6.17-linux-debian7-amd64/zray",
    require => Archive['zray-php5.6']
  }

  zray::apache::vhost { 'zray':
    ensure  => present,
    path    => '/opt/zray',
    enable  => true,
    require => File['/opt/zray']
  }

  zray::php::ini { 'zray':
    ensure  => present,
    path    => '/opt/zray',
    enable  => true,
    require => File['/opt/zray']
  }

  $joomla = {
    'joomla-zray-php5.5' => {
      install_directory => '/opt/zray-php-104202-php5.5.31-linux-debian7-amd64/zray/runtime/var/plugins'
    },
    'joomla-zray-php5.6' => {
      install_directory => '/opt/zray-php-104202-php5.6.17-linux-debian7-amd64/zray/runtime/var/plugins'
    }
  }

  $joomla_default = {
    archive_root_dir  => 'Z-Ray-Joomla-master',
    archive           => 'https://github.com/yireo/Z-Ray-Joomla/archive/master.zip',
    require           => Zray::Php::Ini['zray']
  }

  create_resources('zray::plugin', $joomla, $joomla_default)

  $composer = {
    'composer-zray-php5.5' => {
      install_directory => '/opt/zray-php-104202-php5.5.31-linux-debian7-amd64/zray/runtime/var/plugins',
    },
    'composer-zray-php5.6' => {
      install_directory => '/opt/zray-php-104202-php5.6.17-linux-debian7-amd64/zray/runtime/var/plugins',
    }
  }

  $composer_default = {
    archive_root_dir  => 'Composer-master',
    archive           => 'https://github.com/zend-server-plugins/Composer/archive/master.zip',
    require           => Zray::Php::Ini['zray']
  }

  create_resources('zray::plugin', $composer, $composer_default)

  # Delete the Composer.zip files that come with the default installation as they will interfere with the newer version
  file { ['/opt/zray-php-104202-php5.5.31-linux-debian7-amd64/zray/runtime/var/plugins/Composer.zip', '/opt/zray-php-104202-php5.6.17-linux-debian7-amd64/zray/runtime/var/plugins/Composer.zip']:
    ensure  => absent,
    require => Zray::Php::Ini['zray']
  }

}