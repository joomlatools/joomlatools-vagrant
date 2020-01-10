class profiles::box::cockpit {

  file { ['/etc/cockpit', '/etc/cockpit/ws-certs.d']:
    ensure => directory
  }

  package { ['cockpit', 'cockpit-ws', 'cockpit-bridge', 'cockpit-dashboard', 'cockpit-networkmanager', 'cockpit-packagekit', 'cockpit-storaged', 'cockpit-system']:
    ensure => '210-1~ubuntu18.04.1',
    notify => [Service['cockpit'], File['/usr/share/cockpit/static/login.min.html']]
  }

  ini_setting { 'Cockpit LoginTitle':
    ensure    => present,
    path      => '/etc/cockpit/cockpit.conf',
    section   => 'WebService',
    setting   => 'LoginTitle',
    value     => $::fqdn,
    show_diff => true,
    require => File['/etc/cockpit'],
    notify => Service['cockpit']
  }

  ini_setting { 'Cockpit MaxStartups':
    ensure    => present,
    path      => '/etc/cockpit/cockpit.conf',
    section   => 'WebService',
    setting   => 'MaxStartups',
    value     => 10,
    show_diff => true,
    require => File['/etc/cockpit'],
    notify => Service['cockpit']
  }

  ini_setting { 'Cockpit AllowUnencrypted':
    ensure    => present,
    path      => '/etc/cockpit/cockpit.conf',
    section   => 'WebService',
    setting   => 'AllowUnencrypted',
    value     => true,
    show_diff => true,
    require => File['/etc/cockpit'],
    notify => Service['cockpit']
  }

  service { 'cockpit':
    ensure => 'running',
    enable => true,
    require => [Package['cockpit'], File['/etc/cockpit/ws-certs.d']]
  }

  file { '/usr/share/cockpit/static/login.min.html':
    ensure  => file,
    source  => "puppet:///modules/profiles/cockpit/login.min.html",
    notify  => Service['cockpit']
  }

}