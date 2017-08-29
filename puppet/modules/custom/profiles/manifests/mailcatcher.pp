class profiles::mailcatcher {

  package { ["sqlite3", "libsqlite3-dev"]: }

  exec {'install-mailcatcher-gem':
        user    => vagrant,
        command => 'bash -c "source ~/.rvm/scripts/rvm; gem install mailcatcher"',
        environment => ['HOME=/home/vagrant'],
        creates => '/home/vagrant/.rvm/gems/ruby-2.2.6/bin/mailcatcher',
        timeout => 900,
        require => [Package['sqlite3'], Package['libsqlite3-dev']]
  }

  file { '/etc/init/mailcatcher.conf':
    content => template('profiles/mailcatcher/upstart.conf.erb'),
    require => Exec['install-mailcatcher-gem']
  }

  service { 'mailcatcher':
    ensure   => running,
    provider => upstart,
    hasstatus => true,
    subscribe => File['/etc/init/mailcatcher.conf'],
    require => File['/etc/init/mailcatcher.conf']
  }

}