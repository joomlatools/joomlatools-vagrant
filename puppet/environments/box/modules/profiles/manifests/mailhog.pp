class profiles::mailhog {

  $url  = 'https://github.com/mailhog/MailHog/releases/download/v0.1.8/MailHog_linux_amd64'
  $path = '/usr/local/bin/mailhog'
  $cmd  = "wget --quiet --tries=5 --connect-timeout=10 -O '${path}' ${url}"

  include ::profiles::systemd::reload

  exec { 'download MailHog':
    creates => $path,
    command => $cmd,
    timeout => 3600,
    path    => '/usr/bin'
  } ->
  file { $path:
    ensure => present,
    mode   => '+x'
  } ->
  user { 'mailhog':
    ensure     => present,
    shell      => '/bin/bash',
    managehome => false,
    notify     => File['/etc/systemd/system/mailhog.service']
  }

  file { '/etc/systemd/system/mailhog.service':
    content => template('profiles/mailhog/systemd.service.erb'),
    notify  => [Class['::profiles::systemd::reload'], Service['mailhog']]
  }

  file { '/var/log/mailhog':
    ensure  => directory,
    owner   => mailhog,
    require => User['mailhog'],
    notify  => File['/etc/systemd/system/mailhog.service']
  }

  service { 'mailhog':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Class['::profiles::systemd::reload']
  }
}