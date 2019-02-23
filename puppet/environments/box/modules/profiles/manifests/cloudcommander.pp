class profiles::cloudcommander {

    include ::profiles::nodejs

    exec { 'npm-install-cloudcommander':
        command => 'npm install cloudcmd@5.0.5 -g',
        unless  => 'which cloudcmd',
        environment => ['HOME=/home/vagrant'],
        require => Package['nodejs']
    }

    file { '/etc/init/cloudcommander.conf':
      ensure => file,
      source => "puppet:///modules/profiles/cloudcommander/upstart.conf",
      owner => root,
      group => root,
      require => Exec['npm-install-cloudcommander']
    }

    file { '/root/.cloudcmd.json':
      ensure => file,
      source => "puppet:///modules/profiles/cloudcommander/config.json",
      notify => Service['cloudcommander']
    }

    service {'cloudcommander':
        ensure    => 'running',
        provider  => 'upstart',
        require   => File['/etc/init/cloudcommander.conf']
    }
}