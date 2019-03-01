class profiles::mailcatcher {

  require ::profiles::ruby
  include ::profiles::systemd::reload

  package { ["sqlite3", "libsqlite3-dev"]: }

  exec {'install-mailcatcher-gem':
    user    => vagrant,
    command => '/usr/bin/gem install --user-install --no-ri --no-rdoc mailcatcher',
    environment => ['HOME=/home/vagrant'],
    creates => '/home/vagrant/.gem/ruby/2.5.0/bin/mailcatcher',
    timeout => 900,
    path    => ['/usr/bin/', '/bin/', '/home/vagrant/.gem/ruby/2.5.0/bin/'],
    require => [Package['sqlite3'], Package['libsqlite3-dev']],
    tag     => ['rubygem']
  }

  file { '/lib/systemd/system/mailcatcher.service':
    source  => "puppet:///modules/profiles/mailcatcher/systemd.service",
    notify  => [Class['::profiles::systemd::reload'], Service['mailcatcher']],
    require => Exec['install-mailcatcher-gem']
  }

  service { 'mailcatcher':
    ensure   => running,
    enable   => true,
    require  => Class['::profiles::systemd::reload']
  }

  file { '/usr/bin/catchmail':
    ensure => link,
    target => '/home/vagrant/.gem/ruby/2.5.0/bin/catchmail'
  }

}