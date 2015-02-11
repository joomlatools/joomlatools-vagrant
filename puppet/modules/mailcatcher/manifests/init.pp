class mailcatcher{
  class{"mailcatcher::packages":}
  -> class{"mailcatcher::configs":}
  -> class{"mailcatcher::service":}
}

class mailcatcher::packages{
  package{["sqlite3", "libsqlite3-dev"]:}
  -> package{"mailcatcher":
    ensure => '0.5.12',
    provider => gem
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