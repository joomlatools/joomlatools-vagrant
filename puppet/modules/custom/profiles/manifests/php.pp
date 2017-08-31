class profiles::php {

  include ::php
  include ::php::dev

  file { '/run/php/php-fpm.sock':
    ensure => link,
    target => '/run/php/php7.1-fpm.sock',
    notify => Service['apache']
  }

  apache::dotconf { 'php-fpm':
    source  => 'puppet:///modules/profiles/php/apache.conf'
  }

}