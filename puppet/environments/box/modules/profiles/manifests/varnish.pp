class profiles::varnish {

  include ::profiles::systemd::reload

  File_line['apache-listen-port-80']
    ~> Service['httpd']
    ~> Service['varnish']

  apt::source { 'varnish':
    location   => "https://packagecloud.io/varnishcache/varnish60lts/ubuntu/",
    key        => { 'id' => '48D81A24CB0456F5D59431D94CFCFD6BA750EDCD', 'source' => 'https://packagecloud.io/varnishcache/varnish60lts/gpgkey' }
  }

  package { 'varnish':
    ensure  => latest,
    require => Apt::Source['varnish']
  }

  file { '/etc/systemd/system/varnish.service.d':
    ensure => directory
  }

  file { '/etc/systemd/system/varnish.service.d/override.conf':
    ensure  => file,
    source  => "puppet:///modules/profiles/varnish/override.conf",
    notify  => [Class['::profiles::systemd::reload'], Service['varnish']],
    require => Package['varnish']
  }

  service {'varnish':
    ensure  => running,
    enable  => true,
    require => Class['::profiles::systemd::reload']
  }

  file { '/etc/varnish':
    ensure => directory,
    owner  => vagrant,
    group  => vagrant
  }
  ->
  file { '/etc/varnish/default.vcl':
    ensure  => present,
    owner   => vagrant,
    group   => vagrant,
    mode    => '0774',
    source  => "puppet:///modules/profiles/varnish/joomla.box.vcl",
    require => Package['varnish'],
    notify  => Service['varnish']
  }

  exec { 'varnish-secret':
    command => '/bin/dd if=/dev/random of=/etc/varnish/secret count=1',
    creates => '/etc/varnish/secret',
    notify  => Service['varnish'],
    require =>  File['/etc/varnish']
  }

  file_line { 'apache-listen-port-80':
    path    => '/etc/apache2/ports.conf',
    line    => 'Listen 80',
    match   => '^Listen 80$',
    require => Package['httpd'],
    notify  => Service['httpd']
  }

}