class profiles::php::composer (
    $install_location = '/usr/bin',
    $filename         = 'composer'
) {

  exec { "composer-plugin-changelogs":
    command => "composer global require pyrech/composer-changelogs",
    path    => ['/usr/bin' , '/bin', '/usr/local/bin'],
    creates => '/home/vagrant/.composer/vendor/pyrech/composer-changelogs',
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer',
    require => Anchor['php::end']
  }

}
