class less {
  class{"less::install":}
}

class less::install {
  include nodejs

  exec { 'npm-install-less':
    command => 'npm install -g less',
    unless  => 'which lessc',
    require => Package['nodejs'],
  }

  exec { 'npm-install-autoless':
    command => 'npm install -g autoless',
    unless  => 'which autoless',
    require => Package['nodejs'],
  }
}