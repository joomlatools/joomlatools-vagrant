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

}