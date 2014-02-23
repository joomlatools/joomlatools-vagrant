class phpmanager {
  $script_path = '/home/vagrant/phpmanager'
  $source_path = '/usr/local/src/php'

  class {"phpmanager::install": }
}

class phpmanager::install {
  package { ['autoconf2.13', 'bison', 'flex', 're2c', 'libxml2-dev', 'libxslt1-dev', 'libcurl4-openssl-dev']: ensure  => 'installed' }

  file { '/home/vagrant/phpmanager':
    source => 'puppet:///modules/phpmanager/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant,
  }

  file { $phpmanager::source_path:
    ensure => "directory",
    owner  => vagrant,
    group  => vagrant,
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

  file { '/opt/php':
    ensure => "directory",
    recurse => true,
    owner   => "root",
    group   => "root",
  }
}