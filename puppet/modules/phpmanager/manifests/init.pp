class phpmanager {
  $script_path = '/home/vagrant/phpmanager'
  $source_path = '/usr/local/src'
  $php_source_path = "${php_source_path}/php"
  $installation_path = '/opt'

  class {"phpmanager::install": }
  class {"phpmanager::buildtools": }
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
    owner  => vagrant,
    group  => vagrant,
    mode   => 755,
  }

  file { $phpmanager::php_source_path:
    ensure => "directory",
    owner  => vagrant,
    group  => vagrant,
    mode   => 755,
  }

  exec {"clone-php-source":
    command => "git clone git://git.php.net/php-src.git ${phpmanager::php_source_path}",
    require => Package["git-core"],
    onlyif =>  ["test ! -d ${phpmanager::php_source_path}/.git"]
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

  file { "${phpmanager::installation_path}/php":
    ensure => "directory",
    owner   => "root",
    group   => "root",
  }
}

class phpmanager::buildtools {
  package { ['autoconf2.13', 'flex', 're2c']: ensure  => 'installed' }

  puppi::netinstall { 'bison':
    url => 'http://ftp.gnu.org/gnu/bison/bison-2.2.tar.gz',
    extracted_dir => 'bison-2.2',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/bison-2.2/configure --prefix=${phpmanager::installation_path}/bison-2.2 && make && sudo make install"
  }
}