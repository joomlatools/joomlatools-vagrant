class profiles::cloudcommander {

    include ::profiles::nodejs
    include ::profiles::systemd::reload

    exec { 'npm-install-cloudcommander':
        command => 'npm install cloudcmd@11.8.5 -g',
        unless  => 'which cloudcmd',
        environment => ['HOME=/home/vagrant'],
        require => Package['nodejs']
    }

    file { '/lib/systemd/system/cloudcommander.service':
      ensure  => file,
      source  => "puppet:///modules/profiles/cloudcommander/systemd.service",
      owner   => root,
      group   => root,
      notify  => [Class['::profiles::systemd::reload'], Service['cloudcommander']],
      require => Exec['npm-install-cloudcommander']
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