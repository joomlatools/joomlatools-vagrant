class profiles::wetty {

    include ::profiles::nodejs

    include ::profiles::systemd::reload

    package { 'sshpass':
      ensure => installed
    }
#
    exec { 'yarn-install-wetty':
        command     => '/usr/bin/yarn global add wetty.js',
        unless      => 'which wetty',
        require     => Exec['npm-install-yarn']
    }

    file { '/lib/systemd/system/wetty.service':
      ensure => present,
      source => 'puppet:///modules/profiles/wetty/wetty.service',
      notify => [Class['::profiles::systemd::reload'], Service['wetty']]
    }

    service { 'wetty':
        ensure  => 'running',
        require => Class['::profiles::systemd::reload']
    }

}