class phpmanager {
  $script_path = '/home/vagrant/phpmanager'
  $source_path = '/usr/local/src/php'

  class {"phpmanager::install": }
}

class phpmanager::install {
  file { '/home/vagrant/phpmanager':
    source => 'puppet:///modules/phpmanager/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant,
  }

  file { $phpmanager::source_path:
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 755,
  }

  exec {"clone-php-source":
    command =>"git clone git://git.php.net/php-src.git ${phpmanager::source_path}",
    require => Package["git-core"],
    onlyif => ["test ! -d ${phpmanager::source_path}/.git"]
  }

  exec { 'make-phpmanager-executable':
    command => 'chmod +x /home/vagrant/phpmanager/phpmanager;',
    require => File['/home/vagrant/phpmanager']
  }

  exec { 'add-phpmanager-to-path':
    command => 'echo "export PATH=\$PATH:/home/vagrant/phpmanager" >> /home/vagrant/.profile',
    unless  => 'grep ":/home/vagrant/phpmanager" /home/vagrant/.profile',
    require => Exec['make-phpmanager-executable']
  }
}