class profiles::foliolabs {

  exec { 'add-folioshell':
    command => 'composer global require foliolabs/folioshell:* --no-interaction',
    path    => ['/usr/bin' , '/bin', '/usr/local/bin'],
    unless  => 'test -d /home/vagrant/.composer/vendor/foliolabs/folioshell',
    require => [File['/home/vagrant/scripts'], Anchor['php::end']],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer'
  }


}