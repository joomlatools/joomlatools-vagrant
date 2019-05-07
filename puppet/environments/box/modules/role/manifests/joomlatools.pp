class role::joomlatools inherits role {
  
  exec { 'install cockpit':
    path => '/bin:/usr/bin/:/sbin:/usr/sbin',
    command => 'apt-get install cockpit'
  }

  exec { 'create start up':
    path => '/bin:/usr/bin/:/sbin:/usr/sbin',
    command => 'systemctl start cockpit.socket'
  }

  exec { 'enable start up':
    path => '/bin:/usr/bin/:/sbin:/usr/sbin',
    command => 'systemctl enable cockpit.socket'
  }

  include ::profiles::apache
  include ::profiles::nginx
  include ::profiles::varnish

  include ::profiles::mysql

  include ::profiles::php

  include ::profiles::ruby
  include ::profiles::nodejs

  include ::profiles::phpmyadmin
  include ::profiles::mailcatcher
  include ::profiles::webgrind
  include ::profiles::wetty
  include ::profiles::cloudcommander
  include ::profiles::pimpmylog

  include ::profiles::box

}