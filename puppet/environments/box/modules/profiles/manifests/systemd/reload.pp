class profiles::systemd::reload {

  exec { '/bin/systemctl daemon-reload':
    refreshonly => true
  }

}