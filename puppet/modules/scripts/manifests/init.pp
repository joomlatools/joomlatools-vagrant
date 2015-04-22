class scripts {
  class {"scripts::install": }
}

class scripts::install {
  file { '/home/vagrant/scripts':
    source => 'puppet:///modules/scripts/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant,
  }

  exec { 'make-scripts-executable': 
    command => 'chmod +x /home/vagrant/scripts/remove_dotunderscore',
    require => File['/home/vagrant/scripts']
  }

  exec { 'add-scripts-to-path':
    command => 'echo "export PATH=\$PATH:/home/vagrant/.composer/vendor/bin" >> /home/vagrant/.profile',
    unless  => 'grep ":/home/vagrant/.composer/vendor/bin" /home/vagrant/.profile',
    require => Exec['make-scripts-executable']
  }

  exec { 'add-console':
    command => 'composer global require joomlatools/joomla-console:dev-feature/148-ssl --no-interaction',
    unless  => '[ -d /home/vagrant/.composer/vendor/joomlatools/joomla-console ]',
    require => [File['/home/vagrant/scripts'], Class['Composer']],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer'
  }
}