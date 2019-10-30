class profiles::cloudcommander {

    include ::profiles::nodejs
    include ::profiles::systemd::reload

    package { 'cloudcmd':
      ensure   => present,
      provider => npm
    }

    file { '/lib/systemd/system/cloudcommander.service':
      ensure  => file,
      source  => "puppet:///modules/profiles/cloudcommander/systemd.service",
      owner   => root,
      group   => root,
      notify  => [Class['::profiles::systemd::reload'], Service['cloudcommander']],
      require => Package['cloudcmd']
    }

    file { '/root/.cloudcmd.json':
      ensure => file,
      source => "puppet:///modules/profiles/cloudcommander/config.json",
      notify => Service['cloudcommander']
    }

    service {'cloudcommander':
        ensure    => 'running',
        enable    => true,
        require   => Class['::profiles::systemd::reload']
    }
}