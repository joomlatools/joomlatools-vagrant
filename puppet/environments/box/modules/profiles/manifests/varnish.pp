class profiles::varnish {

  File_line['apache-listen-port-80']
    ~> Service['httpd']
    ~> Service['varnish']

  apt::source { 'varnish':
    location   => "https://packagecloud.io/varnishcache/varnish41/ubuntu/",
    key        => { 'id' => 'C4DEFFEB', 'source' => 'https://packagecloud.io/varnishcache/varnish41/gpgkey' }
  }

  package { 'varnish':
    ensure  => 'latest',
    require => Apt::Source['varnish']
  }

  service {'varnish':
    ensure  => running,
    restart => 'service varnish restart',
    require => Package['varnish']
  }

  file { '/etc/default/varnish':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/profiles/varnish/varnish.conf",
    require => Package['varnish'],
    notify  => Service['varnish']
  }

  file { '/etc/varnish/default.vcl':
    ensure  => present,
    owner   => vagrant,
    group   => vagrant,
    mode    => '0774',
    source  => "puppet:///modules/profiles/varnish/joomla.box.vcl",
    require => Package['varnish'],
    notify  => Service['varnish']
  }

  file_line { 'apache-listen-port-80':
    path    => '/etc/apache2/ports.conf',
    line    => 'Listen 80',
    match   => '^Listen 80$',
    require => Package['httpd'],
    notify  => Service['httpd']
  }

}