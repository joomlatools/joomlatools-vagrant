class scripts {

  file { '/home/vagrant/scripts':
    source => 'puppet:///modules/scripts/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant,
  }

  exec { 'make-scripts-executable': 
    command => 'chmod +x /home/vagrant/scripts/remove_dotunderscore /home/vagrant/scripts/updater/login.sh',
    require => File['/home/vagrant/scripts']
  }

  exec { 'add-scripts-to-path':
    command => 'echo "export PATH=\$PATH:/home/vagrant/.composer/vendor/bin" >> /home/vagrant/.profile',
    unless  => 'grep ":/home/vagrant/.composer/vendor/bin" /home/vagrant/.profile',
    require => Exec['make-scripts-executable']
  }

  exec { 'add-console':
    command => 'composer global require joomlatools/joomla-console:* --no-interaction',
    unless  => '[ -d /home/vagrant/.composer/vendor/joomlatools/joomla-console ]',
    require => [File['/home/vagrant/scripts'], Class['Composer']],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer'
  }

  file_line { 'joomla-console-updater':
    path    => '/home/vagrant/.bash_profile',
    line    => '/home/vagrant/scripts/updater/login.sh',
    require => Exec['make-scripts-executable']
  }

  file_line { 'cd-to-www-dir':
    path    => '/home/vagrant/.bash_profile',
    line    => 'cd /var/www'
  }
}