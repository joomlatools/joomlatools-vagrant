class phpmanager {
  $script_path = '/home/vagrant/phpmanager'
  $source_path = '/usr/local/src'
  $php_source_path = "${source_path}/php"
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
    require => File["$phpmanager::source_path"]
  }

  file { '/etc/bash_completion.d/phpmanager':
    ensure => 'link',
    target => '/home/vagrant/phpmanager/phpmanager.complete',
    require => File['/home/vagrant/phpmanager']
  }

  exec {"clone-php-source":
    command => "git clone git://git.php.net/php-src.git ${phpmanager::php_source_path}",
    require => File["${phpmanager::php_source_path}"],
    onlyif =>  ["test ! -d ${phpmanager::php_source_path}/.git"],
    user => vagrant,
    group => vagrant
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
  package { ['autoconf2.13', 're2c', 'apache2-prefork-dev', 'bison']: ensure  => 'installed' }
  package { ['libcurl4-openssl-dev', 'libmysqlclient-dev', 'libmcrypt-dev', 'libbz2-dev', 'libjpeg-dev', 'libpng12-dev', 'libfreetype6-dev', 'libicu-dev', 'libxml2-dev', 'libxslt-dev']: ensure => 'installed' }

  puppi::netinstall { 'bison':
    url => 'http://ftp.gnu.org/gnu/bison/bison-2.2.tar.gz',
    extracted_dir => 'bison-2.2',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/bison-2.2/configure --prefix=${phpmanager::installation_path}/bison-2.2 && make && sudo make install"
  }

  puppi::netinstall { 'flex':
    path => ["${phpmanager::installation_path}/bison-2.2/bin:/bin:/sbin:/usr/bin:/usr/sbin"],
    url => 'http://fossies.org/unix/misc/old/flex-2.5.4a.tar.gz',
    extracted_dir => 'flex-2.5.4',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/flex-2.5.4/configure --prefix=${phpmanager::installation_path}/flex-2.5.4 && make && sudo make install",
    require => Puppi::Netinstall['bison'],
  }

  puppi::netinstall { 'mysql-5.1.73':
    url => 'http://fossies.org/linux/misc/mysql-5.1.73-linux-x86_64-glibc23.tar.gz',
    extracted_dir => 'mysql-5.1.73-linux-x86_64-glibc23',
    destination_dir => $phpmanager::installation_path,
    postextract_command => "mkdir -p ${phpmanager::installation_path}/mysql-5.1.73-linux-x86_64-glibc23/lib/x86_64-linux-gnu && ln -s ${phpmanager::installation_path}/mysql-5.1.73-linux-x86_64-glibc23/lib/libmysqlclient.so ${phpmanager::installation_path}/mysql-5.1.73-linux-x86_64-glibc23/lib/x86_64-linux-gnu/libmysqlclient.so"
  }
}