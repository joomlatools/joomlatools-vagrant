class profiles::wetty {

    include ::profiles::nodejs

    include ::profiles::systemd::reload
  
    exec { 'yarn-install-wetty':
        command     => '/usr/bin/yarn global add wetty',
        unless      => 'which wetty',
        notify      => Service['wetty'],
        require     => Package['yarn']
    }

    file { '/lib/systemd/system/wetty.service':
      ensure => present,
      source => 'puppet:///modules/profiles/wetty/wetty.service',
      notify => [Class['::profiles::systemd::reload'], Service['wetty']]
    }

    service { 'wetty':
        ensure  => 'running',
        enable  => true,
        require => Class['::profiles::systemd::reload']
    }

    exec { 'wetty-add-vagrant-pubkey-to-authorized_keys':
      command => 'cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys',
      unless  => 'grep "vagrant@joomlatools" /home/vagrant/.ssh/authorized_keys',
      user    => vagrant,
      require => Ssh_keygen['vagrant']
    }

    file { '/home/vagrant/.ssh/config':
      content => "Host localhost\n\tStrictHostKeyChecking no\n",
      owner => vagrant,
      group => vagrant
    }

}