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
    command => 'echo "export PATH=\$PATH:/home/vagrant/scripts:/home/vagrant/scripts/joomla-console/bin" >> /home/vagrant/.profile',
    unless  => 'grep ":/home/vagrant/scripts/joomla-console/bin" /home/vagrant/.profile',
    require => Exec['make-scripts-executable']
  }

  exec { 'add-console':
    command => 'git clone https://github.com/joomlatools/joomla-console.git /home/vagrant/scripts/joomla-console &&
                cd /home/vagrant/scripts/joomla-console &&
                composer install &&
                chown -R vagrant:vagrant /home/vagrant/scripts/joomla-console &&
                chmod +x /home/vagrant/scripts/joomla-console/bin/joomla
    ',
    unless  => '[ -d /home/vagrant/scripts/joomla-console ]',
    require => [File['/home/vagrant/scripts'], Class['Composer'], Package['git-core']]
  }
}