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
    command => 'echo "export PATH=\$PATH:/home/vagrant/.composer/vendor/bin" >> /home/vagrant/.bash_profile',
    unless  => 'grep ":/home/vagrant/.composer/vendor/bin" /home/vagrant/.bash_profile',
    require => Exec['make-scripts-executable']
  }

  exec { 'add-console':
    command => 'composer global require joomlatools/joomla-console:* --no-interaction',
    unless  => '[ -d /home/vagrant/.composer/vendor/joomlatools/joomla-console ]',
    require => [File['/home/vagrant/scripts'], Class['Composer']],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer'
  }

  exec { 'add-console-joomlatools-plugin':
    command => 'composer --working-dir=/home/vagrant/.composer/vendor/joomlatools/joomla-console/plugins require joomlatools/joomla-console-joomlatools --no-interaction',
    unless  => '[ -d /home/vagrant/.composer/vendor/joomlatools/joomla-console/plugins/vendor/joomlatools/joomla-console-joomlatools ]',
    require => Exec['add-console'],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer'
  }

  file {'/home/vagrant/.bash_profile':
    ensure => file,
    owner  => vagrant,
    group  => vagrant,
    notify => [File_line['joomla-console-updater'], File_line['cd-to-www-dir']]
  }

  file_line { 'joomla-console-updater':
    path    => '/home/vagrant/.bash_profile',
    line    => '/home/vagrant/scripts/updater/login.sh',
    require => Exec['make-scripts-executable']
  }

  file_line { 'load-bashrc':
    path    => '/home/vagrant/.bash_profile',
    line    => '[ -f ~/.bashrc ] && . ~/.bashrc',
    require => File['/home/vagrant/.bash_profile']
  }

  file_line { 'cd-to-www-dir':
    path    => '/home/vagrant/.bash_profile',
    line    => '[ -d /var/www ] && cd /var/www',
    require => File_Line['load-bashrc']
  }
}