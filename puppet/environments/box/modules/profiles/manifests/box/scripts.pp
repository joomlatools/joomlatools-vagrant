class profiles::box::scripts {

  file { '/home/vagrant/scripts':
    source => 'puppet:///modules/profiles/box/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant,
  }

  exec { 'make-scripts-executable': 
    command => 'chmod +x /home/vagrant/scripts/remove_dotunderscore /home/vagrant/scripts/updater/login.sh',
    unless  => ['test -x /home/vagrant/scripts/remove_dotunderscore', 'test -x /home/vagrant/scripts/updater/login.sh'],
    require => File['/home/vagrant/scripts']
  }

  exec { 'add-scripts-to-path':
    command => 'echo "export PATH=\$PATH:/home/vagrant/.composer/vendor/bin" >> /home/vagrant/.bash_profile',
    unless  => 'grep ":/home/vagrant/.composer/vendor/bin" /home/vagrant/.bash_profile',
    require => Exec['make-scripts-executable']
  }

  exec { 'add-console':
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
    require => [Exec['add-console'], File['/home/vagrant/.joomlatools/plugins']],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer'
  }

  file {'/home/vagrant/.bash_profile':
    ensure => file,
    owner  => vagrant,
    group  => vagrant,
    notify => [File_line['joomlatools-console-updater'], File_line['cd-to-www-dir']]
  }

  file_line { 'joomlatools-console-updater':
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
