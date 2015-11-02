class profiles::php(
  $apache_ini_settings = [],
  $cli_ini_settings    = []
) {

  Php::Extension <| |>
    -> Php::Config <| |>

  Package['php5-common']
    -> Package['php5-dev']
    -> Package['php5-cli']
    -> Php::Extension <| |>

  Php::Extension <| |> ~> Service['php5-fpm']
  Php::Fpm::Pool <| |> ~> Service['php5-fpm']

  apt::key { 'php5':
    key  => '14AA40EC0831756756D7F66C4F4EA0AAE5267A6C'
  }

  apt::ppa { 'ppa:ondrej/php5-5.6':
      require => Apt::Key['php5']
  }

  include ::php
  include ::php::dev

  class { 'php::apache':
    settings => $apache_ini_settings
  }

  class { 'php::cli':
    settings => $cli_ini_settings
  }

  class { ['php::composer', 'php::composer::auto_update']: }
  class { ['php::extension::apcu', 'php::extension::curl', 'php::extension::gd', 'php::extension::imagick', 'php::extension::mcrypt', 'php::extension::mysql']: }
  class { 'php::extension::xdebug': }

  class { 'php::pear': }

  php::extension { 'oauth':
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
  }

}