class profiles::php {

  include ::php
  include ::php::dev

  $version = hiera('php::globals::php_version', '7.1')

  file { '/run/php/php-fpm.sock':
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

}