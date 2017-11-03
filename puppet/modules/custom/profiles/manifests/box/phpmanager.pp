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
    command => 'chmod +x /home/vagrant/phpmanager/phpmanager',
    unless  => 'test -x /home/vagrant/phpmanager/phpmanager',
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

  exec { 'symlink-freetype.h':
    command => 'mkdir /usr/include/freetype2/freetype && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h',
    unless  => 'bash -c "test -f /usr/include/freetype2/freetype/freetype.h"',
    require => Package['libfreetype6-dev']
  }

}