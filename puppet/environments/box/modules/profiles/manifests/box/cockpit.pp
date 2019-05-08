class profiles::box::cockpit {

  contain ::apt

  ::apt::source { 'cockpit':
    location => 'http://ppa.launchpad.net/cockpit-project/cockpit/ubuntu',
    repos    => 'main',
    before   => Class['apt::update']
  }

  package { 'cockpit': }

  ini_setting { 'Cockpit LoginTitle':
    ensure    => present,
    path      => '/etc/cockpit/cockpit.conf',
    section   => 'WebService',
    setting   => 'LoginTitle',
    value     => $::fqdn,
    show_diff => true,
  }

  ini_setting { 'Cockpit MaxStartups':
    ensure    => present,
    path      => '/etc/cockpit/cockpit.conf',
    section   => 'WebService',
    setting   => 'MaxStartups',
    value     => 10,
    show_diff => true,
  }

  ini_setting { 'Cockpit AllowUnencrypted':
    ensure    => present,
    path      => '/etc/cockpit/cockpit.conf',
    section   => 'WebService',
    setting   => 'AllowUnencrypted',
    value     => true,
    show_diff => true,
  }

  service { 'cockpit':
    ensure => 'running',
    enable => true,
  }
}