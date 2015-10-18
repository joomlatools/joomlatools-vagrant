class cloudcommander {
    include nodejs

    exec { 'npm-install-cloudcommander':
        command => 'npm install cloudcmd -g',
        unless  => 'which cloudcmd',
        environment => ['HOME=/home/vagrant'],
        require => Package['nodejs']
    }

    file { '/etc/init/cloudcommander.conf':
      ensure => file,
      source => "puppet:///modules/cloudcommander/upstart.conf",
      owner => root,
      group => root,
      require => Exec['npm-install-cloudcommander']
    }

    file { '/root/.cloudcmd.json':
      ensure => file,
      source => "puppet:///modules/cloudcommander/config.json",
      notify => Service['cloudcommander']
    }

    service {'cloudcommander':
        ensure    => 'running',
        provider  => 'upstart',
        require   => File['/etc/init/cloudcommander.conf']
    }
}