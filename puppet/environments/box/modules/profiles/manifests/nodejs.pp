class profiles::nodejs {
  include ::apt

  exec { 'nodejs-setup-source':
    command => '/usr/bin/curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -',
    creates => '/etc/apt/sources.list.d/nodesource.list',
    require => Package['curl']
  }

  package { 'nodejs':
    ensure  => latest,
    require => Exec['nodejs-setup-source']
  }

}