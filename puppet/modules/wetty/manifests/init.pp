class wetty {
    include nodejs

    exec { 'npm-install-wetty':
        command => 'npm install -g wetty@0.0.9',
        unless  => 'which wetty',
        environment => ['HOME=/home/vagrant'],
        require => Package['nodejs']
    }

    # Overwrite with our edited app.js that forces /bin/login to the vagrant user
    file { '/usr/lib/node_modules/wetty/app.js':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
        source  => 'puppet:///modules/wetty/app.js',
        require => Exec['npm-install-wetty']
    }

    exec { 'install-wetty-as-daemon':
        command => 'cp /usr/lib/node_modules/wetty/bin/wetty.conf /etc/init',
        unless  => 'bash -c "test -f /etc/init/wetty.conf"',
        require => File['/usr/lib/node_modules/wetty/app.js']
    }

    service {'wetty':
        ensure    => 'running',
        provider  => 'upstart',
        require   => Exec['install-wetty-as-daemon']
    }
}