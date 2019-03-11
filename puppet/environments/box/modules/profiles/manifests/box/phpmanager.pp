class profiles::box::phpmanager {
  $script_path = '/home/vagrant/phpmanager'
  $source_path = '/usr/local/src'
  $php_source_path = "${source_path}/php"
  $xdebug_source_path = "${source_path}/xdebug"
  $installation_path = '/opt'

  include ::profiles::box::phpmanager::install
}

class profiles::box::phpmanager::install {
  file { '/home/vagrant/phpmanager':
    source => 'puppet:///modules/profiles/box/phpmanager/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant
  }

  file { $::profiles::box::phpmanager::source_path:
    ensure => "directory",
    owner  => vagrant,
    group  => vagrant,
    mode   => '0755',
    require => Package['git']
  }

  file { $::profiles::box::phpmanager::php_source_path:
    ensure => "directory",
    owner  => vagrant,
    group  => vagrant,
    mode   => '0755',
    require => File["$::profiles::box::phpmanager::source_path"]
  }

  file { $::profiles::box::phpmanager::xdebug_source_path:
    ensure => "directory",
    owner  => vagrant,
    group  => vagrant,
    mode   => '0755',
    require => File["$::profiles::box::phpmanager::source_path"]
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
    command => 'echo "export PATH=\$PATH:/home/vagrant/phpmanager" >> /home/vagrant/.bashrc',
    unless  => 'grep ":/home/vagrant/phpmanager" /home/vagrant/.bashrc',
    require => Exec['make-phpmanager-executable']
  }
}