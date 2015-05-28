class mailcatcher {

  package { ["sqlite3", "libsqlite3-dev"]: }

  exec {'install-mailcatcher-gem':
        user    => vagrant,
        command => 'bash -c "source ~/.rvm/scripts/rvm; gem install mailcatcher"',
        environment => ['HOME=/home/vagrant'],
        path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vagrant/.rvm/bin/',
        require => [Package['sqlite3'], Package['libsqlite3-dev']]
  }

  file { '/etc/init/mailcatcher.conf':
    content => template("mailcatcher/upstart.conf.erb"),
    require => Exec['install-mailcatcher-gem']
  }

  service{"mailcatcher":
    ensure   => running,
    provider => upstart,
    hasstatus => true,
    subscribe => File['/etc/init/mailcatcher.conf'],
    require => File['/etc/init/mailcatcher.conf']
  }
}