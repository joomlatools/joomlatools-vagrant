class profiles::joomlatools {

  exec { 'add-joomlatools-console':
    command => 'composer global require joomlatools/console:* --no-interaction',
    path    => ['/usr/bin' , '/bin', '/usr/local/bin'],
    unless  => 'test -d /home/vagrant/.composer/vendor/joomlatools/console',
    require => [File['/home/vagrant/scripts'], Anchor['php::end']],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer'
  }

  file { ['/home/vagrant/.joomlatools/', '/home/vagrant/.joomlatools/plugins']:
    ensure => directory,
    owner  => vagrant,
    group  => vagrant
  }

  exec { 'add-console-joomlatools-plugin':
    command => 'composer --working-dir=/home/vagrant/.joomlatools/plugins require joomlatools/console-joomlatools --no-interaction',
    path    => ['/usr/bin' , '/bin', '/usr/local/bin'],
    unless  => 'test -d /home/vagrant/.joomlatools/plugins/vendor/joomlatools/console-joomlatools',
    require => [Exec['add-joomlatools-console'], File['/home/vagrant/.joomlatools/plugins']],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer'
  }

}