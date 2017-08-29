class profiles::php {

  #apt::key { '4F4EA0AAE5267A6C': }

  #apt::ppa { 'ppa:ondrej/php5-5.6':
  #  require => Apt::Key['4F4EA0AAE5267A6C']
  #}

  class { '::php':
    service       => 'apache',
    version       => 'latest',
    module_prefix => '',
    require       => Package['apache'],
  }

  php::module { 'php5-mysql': }
  php::module { 'php5-cli': }
  php::module { 'php5-curl': }
  php::module { 'php5-gd': }
  php::module { 'php5-imagick': }
  php::module { 'php5-intl': }
  php::module { 'php5-mcrypt': }
  php::module { 'php5-sqlite': }
  php::module { 'php5-apcu': }
  # php::module { 'php5-xdebug': }

  class { 'profiles::php::composer':
    require => Package['php5', 'curl']
  }

  class { 'php::devel':
    require => Class['::php'],
  }

  class { 'php::pear':
    require => Class['::php'],
  }

  php::pear::config {
    download_dir: value => "/tmp/pear/download",
      require => Class['php::pear']
  }

  php::pear::module { 'Console_CommandLine':
    use_package => false
  }

  php::pear::module { 'Phing':
    use_package => false,
    repository  => 'pear.phing.info'
  }

  # Required extensions
  package { 'libyaml-dev':
    ensure => present,
  }

  ::php::pecl::module { 'yaml':
    use_package => no,
    ensure => present,
    require => [Php::Pear::Config['download_dir'], Package['libyaml-dev']]
  }

  ::profiles::php::ini { 'yaml.ini':
    value   => [
      'extension=yaml.so'
    ],
    ini     => '/etc/php5/mods-available/yaml.ini',
    notify  => Service['apache'],
    require => Php::Pecl::Module['yaml']
  }

  file { ['/etc/php5/apache2/conf.d/20-yaml.ini', '/etc/php5/cli/conf.d/20-yaml.ini']:
    ensure => link,
    target => '/etc/php5/mods-available/yaml.ini',
    require => ::Profiles::Php::Ini['yaml.ini']
  }

  php::pecl::module { 'oauth':
    use_package => yes,
    ensure      => present,
    require     => Php::Pear::Config['download_dir']
  }

  ::profiles::php::ini { 'oauth.ini':
    value   => [
      'extension=oauth.so'
    ],
    ini     => '/etc/php5/mods-available/oauth.ini',
    notify  => Service['apache'],
    require => Php::Pecl::Module['oauth']
  }

  file { ['/etc/php5/apache2/conf.d/20-oauth.ini', '/etc/php5/cli/conf.d/20-oauth.ini']:
    ensure => link,
    target => '/etc/php5/mods-available/oauth.ini',
    require => ::Profiles::Php::Ini['oauth.ini']
  }

  # Custom configuration
  ::profiles::php::ini { 'custom':
    value   => [
      'sendmail_path = /home/vagrant/.rvm/gems/ruby-2.2.1/bin/catchmail -fnoreply@example.com',
      'display_errors = On',
      'error_reporting = E_ALL & ~E_NOTICE',
      'display_startup_errors = On',
      'upload_max_filesize = "256M"',
      'post_max_size = "256M"',
      'memory_limit = "256M"',
      'date.timezone = "UTC"',
      'xdebug.remote_autostart = 0',
      'xdebug.remote_connect_back = 1',
      'xdebug.remote_enable = 1',
      'xdebug.remote_handler = "dbgp"',
      'xdebug.remote_port = 9000',
      'xdebug.remote_host = "33.33.33.1"',
      'xdebug.show_local_vars = 1',
      'xdebug.profiler_enable = 0',
      'xdebug.profiler_enable_trigger = 0',
      'xdebug.max_nesting_level = 1000',
      'xdebug.profiler_output_dir = /var/www/',
      'openssl.cafile = /etc/ssl/certs/ca-certificates.crt',
      'openssl.capath = /usr/lib/ssl/'
    ],
    ini     => '/etc/php5/mods-available/custom.ini',
    notify  => Service['apache'],
    require => Class['::php']
  }

  file { ['/etc/php5/apache2/conf.d/99-custom.ini', '/etc/php5/cli/conf.d/99-custom.ini']:
    ensure => link,
    target => '/etc/php5/mods-available/custom.ini',
    require => ::Profiles::Php::Ini['custom']
  }

  # ::profiles::php::ini { 'xdebug.ini':
  #   value   => [
  #     '; zend_extension=xdebug.so'
  #   ],
  #   ini     => '/etc/php5/mods-available/xdebug.ini',
  #   notify  => Service['apache'],
  #   require => Php::Module['php5-xdebug']
  # }

}