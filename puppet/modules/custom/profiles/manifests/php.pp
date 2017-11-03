class profiles::php {

  include ::php
  include ::php::dev

  include ::profiles::php::composer

  $version = hiera('php::globals::php_version', '7.1')

  file { '/opt/php/php-fpm.sock':
    ensure => link,
    target => '/run/php/php7.1-fpm.sock',
    notify => Service['apache']
  }

  apache::dotconf { 'php-fpm':
    source  => 'puppet:///modules/profiles/php/apache.conf'
  }

  exec { 'pecl-alternative':
    command => "mv /usr/bin/pecl /usr/bin/pecl${version} && /usr/bin/update-alternatives --install /usr/bin/pecl pecl /usr/bin/pecl${version} 70",
    unless  => "/usr/bin/test -h /usr/bin/pecl",
    require => Anchor['php::end']
  }

  exec { 'pear-alternative':
    command => "mv /usr/bin/pear /usr/bin/pear${version} && /usr/bin/update-alternatives --install /usr/bin/pear pear /usr/bin/pear${version} 70",
    unless  => "/usr/bin/test -h /usr/bin/pear",
    require => Anchor['php::end']
  }

  exec { 'php-fpm-alternative':
    command => "/usr/bin/update-alternatives --install /usr/sbin/php-fpm php-fpm /usr/sbin/php-fpm${version} 70",
    unless  => "/usr/bin/test -h /usr/sbin/php-fpm",
    require => Anchor['php::end']
  }

  file { '/etc/init/php-fpm.conf':
    ensure => present,
    source => 'puppet:///modules/profiles/php/php-fpm.conf'
  }

  ini_setting { 'php-fpm-no-daemonize':
    ensure  => present,
    value   => 'no',
    path    => "/etc/php/${version}/fpm/php-fpm.conf",
    section => 'global',
    setting => 'daemonize',
    require => Anchor['php::end'],
    notify  => Service['php-fpm']
  }

  service { 'php-fpm':
    ensure     => running,
    provider   => 'upstart',
    hasrestart => true,
    restart    => 'service php-fpm reload',
    hasstatus  => true,
    subscribe  => File['/etc/init/php-fpm.conf'],
    require    => Anchor['php::end']
  }

  ::php::config { 'php.ini-template':
    file   => '/home/vagrant/php.ini-template',
    config => hiera('php::settings', {})
  }

  # Disable Xdebug by default
  file { "/etc/php/${version}/mods-available/xdebug.ini":
      ensure  => file,
      content => '; zend_extension=xdebug.so',
      require => Anchor['php::end']
  }

}