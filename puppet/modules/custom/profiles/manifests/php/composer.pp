class profiles::php::composer (
    $install_location = '/usr/bin',
    $filename         = 'composer'
) {

  exec { "composer-${install_location}":
    command     => "curl -sS https://getcomposer.org/installer | php -- --install-dir=/tmp/ && mv /tmp/composer.phar ${install_location}/${filename}",
    environment => ['HOME=/root'],
    unless      => "test -x ${install_location}/${filename}",
    path        => ['/usr/bin' , '/bin']
  }

  exec { "composer-plugin-changelogs":
    command => "composer global require pyrech/composer-changelogs",
    path    => ['/usr/bin' , '/bin', '/usr/local/bin'],
    creates => '/home/vagrant/.composer/vendor/pyrech/composer-changelogs',
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer',
    require => Exec["composer-${install_location}"]
  }

  exec { "composer-plugin-prestissimo":
    command => "composer global require hirak/prestissimo",
    path    => ['/usr/bin' , '/bin', '/usr/local/bin'],
    creates => '/home/vagrant/.composer/vendor/hirak/prestissimo',
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer',
    require => Exec["composer-${install_location}"]
  }

}
