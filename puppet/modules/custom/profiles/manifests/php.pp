class profiles::php {

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
    require => Class['php'],
  }

  class { 'php::pear':
    require => Class['php'],
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

/*  php::extension { 'oauth':
    ensure   => latest,
    package  => 'oauth',
    provider => 'pecl',
    require  => Class['::php::dev']
  }

  php::config { 'php-extension-oauth':
    file   => "${::php::params::config_root_ini}/oauth.ini",
    config => [
      'set ".anon/extension" "oauth.so"'
    ],
    require => Php::Extension['oauth']
  }

  exec { 'php-enable-oauth':
    command => '/usr/sbin/php5enmod oauth',
    unless  => '/usr/bin/php -i | grep oauth.ini',
    require => Php::Config['php-extension-oauth']
  }*/

}