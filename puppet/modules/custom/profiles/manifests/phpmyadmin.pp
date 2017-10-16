class profiles::phpmyadmin {

  require ::profiles::apache
  require ::profiles::php
  require ::profiles::mysql

  include ::phpmyadmin

  Service['mysql'] ~> Exec['creating-phpmyadmin-controluser']

  apache::vhost { 'phpmyadmin':
    server_name   => 'phpmyadmin',
    serveraliases => 'phpmyadmin.joomla.box',
    docroot       => '/usr/share/phpmyadmin',
    port          => 8080,
    priority      => '10'
  }

}