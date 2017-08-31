class profiles::box::phpmanager {
  $script_path = '/home/vagrant/phpmanager'
  $source_path = '/usr/local/src'
  $php_source_path = "${source_path}/php"
  $xdebug_source_path = "${source_path}/xdebug"
  $installation_path = '/opt'

  include ::profiles::box::phpmanager::install
  include ::profiles::box::phpmanager::buildtools
}

class profiles::box::phpmanager::install {
  file { '/home/vagrant/phpmanager':
    source => 'puppet:///modules/profiles/box/phpmanager/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant
  }

  file { $phpmanager::source_path:
    ensure => "directory",
    owner  => vagrant,
    group  => vagrant,
    mode   => 755,
    require => Package['git-core']
  }

  file { $phpmanager::php_source_path:
    ensure => "directory",
    owner  => vagrant,
    group  => vagrant,
    mode   => 755,
    require => File["$phpmanager::source_path"]
  }

  file { $phpmanager::xdebug_source_path:
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

  exec { 'make-phpmanager-executable':
    command => 'chmod +x /home/vagrant/phpmanager/phpmanager;',
    require => File['/home/vagrant/phpmanager']
  }

  exec { 'add-phpmanager-to-path':
    command => 'echo "export PATH=\$PATH:/home/vagrant/phpmanager" >> /home/vagrant/.bash_profile',
    unless  => 'grep ":/home/vagrant/phpmanager" /home/vagrant/.bash_profile',
    require => Exec['make-phpmanager-executable']
  }

  file { "${phpmanager::installation_path}/php":
    ensure => "directory",
    owner   => "root",
    group   => "root",
  }
}

class profiles::box::phpmanager::buildtools {
  package { ['autoconf2.13', 're2c', 'apache2-dev', 'bison', 'g++-4.4', 'gcc-4.4']: ensure  => 'installed' }
  package { ['libcurl4-openssl-dev', 'libmariadbclient-dev', 'libmcrypt-dev', 'libbz2-dev', 'libjpeg-dev', 'libpng12-dev', 'libfreetype6-dev', 'libicu-dev', 'libxml2-dev', 'libxslt1-dev', 'libssl-dev']: ensure => 'installed' }

  puppi::netinstall { 'bison-2.2':
    url => 'http://ftp.gnu.org/gnu/bison/bison-2.2.tar.gz',
    extracted_dir => 'bison-2.2',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/bison-2.2/configure --prefix=${phpmanager::installation_path}/bison-2.2 && make && sudo make install",
    require => Package['build-essential']
  }

  puppi::netinstall { 'bison-2.4':
    url => 'http://ftp.gnu.org/gnu/bison/bison-2.4.tar.gz',
    extracted_dir => 'bison-2.4',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/bison-2.4/configure --prefix=${phpmanager::installation_path}/bison-2.4 && make && sudo make install",
    require => Package['build-essential']
  }

  puppi::netinstall { 'flex-2.5.4a':
    path => ["${phpmanager::installation_path}/bison-2.2/bin:/bin:/sbin:/usr/bin:/usr/sbin"],
    url => 'ftp://ftp.gnome.org/mirror/temp/sf2015/f/fl/flex/flex/2.5.4.a/flex-2.5.4a.tar.gz',
    extracted_dir => 'flex-2.5.4',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/flex-2.5.4/configure --prefix=${phpmanager::installation_path}/flex-2.5.4 && make && sudo make install",
    require => Puppi::Netinstall['bison-2.2'],
  }

  puppi::netinstall { 'openssl-0.9.7g':
    url => 'https://www.openssl.org/source/old/0.9.x/openssl-0.9.7g.tar.gz',
    retrieve_args => '--no-check-certificate',
    extracted_dir => 'openssl-0.9.7g',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/openssl-0.9.7g/config --prefix=${phpmanager::installation_path}/openssl-0.9.7g -fPIC no-gost && make && make install && ln -s /opt/openssl-0.9.7g/lib /opt/openssl-0.9.7g/lib/x86_64-linux-gnu",
    require => Package['build-essential']
  }

  puppi::netinstall { 'openssl-1.0.1f':
    url => 'ftp://ftp.openssl.org/source/old/1.0.1/openssl-1.0.1f.tar.gz',
    retrieve_args => '--no-check-certificate',
    extracted_dir => 'openssl-1.0.1f',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/openssl-1.0.1f/config --prefix=${phpmanager::installation_path}/openssl-1.0.1f -fPIC no-gost && make && make depend && make install_sw && ln -s /opt/openssl-1.0.1f/lib /opt/openssl-1.0.1f/lib/x86_64-linux-gnu",
    require => Package['build-essential']
  }

  puppi::netinstall { 'openssl-1.0.2g':
    url => 'https://www.openssl.org/source/openssl-1.0.2g.tar.gz',
    retrieve_args => '--no-check-certificate',
    extracted_dir => 'openssl-1.0.2g',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/openssl-1.0.2g/config --prefix=${phpmanager::installation_path}/openssl-1.0.2g -fPIC no-gost && make && make depend && make install_sw && ln -s /opt/openssl-1.0.2g/lib /opt/openssl-1.0.2g/lib/x86_64-linux-gnu",
    require => Package['build-essential']
  }

  puppi::netinstall { 'libxml2-2.7.8':
    url => 'ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz',
    extracted_dir => 'libxml2-2.7.8',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/libxml2-2.7.8/configure --prefix=${phpmanager::installation_path}/libxml2-2.7.8 && make && sudo make install",
    require => Package['build-essential']
  }

  puppi::netinstall { 'libxslt-1.1.26':
    url => 'ftp://xmlsoft.org/libxslt/libxslt-1.1.26.tar.gz',
    extracted_dir => 'libxslt-1.1.26',
    destination_dir => $phpmanager::source_path,
    postextract_command => "${phpmanager::source_path}/libxslt-1.1.26/configure --prefix=${phpmanager::installation_path}/libxslt-1.1.26 --with-libxml-prefix=/opt/libxml2-2.7.8/ --with-libxml-libs-prefix=/opt/libxml2-2.7.8/ --with-libxml-include-prefix=/opt/libxml2-2.7.8/  && make && sudo make install",
    require => Puppi::Netinstall['libxml2-2.7.8']
  }

  puppi::netinstall { 'curl-7.15.3':
    url => 'ftp://ftp.belnet.be/mirror/pub/ftp.sunet.se/pub/www/utilities/curl/curl-7.15.3.tar.gz',
    extracted_dir => 'curl-7.15.3',
    destination_dir => $phpmanager::source_path,
    require => File["$phpmanager::source_path"]
  }

  exec { 'symlink-freetype.h':
    command => 'mkdir /usr/include/freetype2/freetype && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h',
    unless  => 'bash -c "test -f /usr/include/freetype2/freetype/freetype.h"',
    require => Package['libfreetype6-dev']
  }

}