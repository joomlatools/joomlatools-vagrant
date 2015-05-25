class mailcatcher{
  class{"mailcatcher::packages":}
  -> class{"mailcatcher::configs":}
  -> class{"mailcatcher::service":}
}

class mailcatcher::packages{
  package{["sqlite3", "libsqlite3-dev"]:}
  -> exec {'install-mailcatcher-gem':
        user    => vagrant,
        command => 'bash -c "source ~/.rvm/scripts/rvm; gem install mailcatcher"',
        environment => ['HOME=/home/vagrant'],
        path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vagrant/.rvm/bin/',
  }
}

class mailcatcher::configs{
  file{"/etc/init/mailcatcher.conf":
    content => template("mailcatcher/upstart.conf.erb")
  }
}

class  mailcatcher::service{
  # mailcatcher  --http-ip 0.0.0.0
  service{"mailcatcher":
    ensure   => running,
    provider => upstart,
    hasstatus => true,
    subscribe => Class['mailcatcher::configs']
  }
}