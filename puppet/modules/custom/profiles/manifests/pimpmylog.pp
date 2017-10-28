class profiles::pimpmylog {

    file { '/usr/share/pimpmylog':
        ensure => present,
        owner  => vagrant,
        group  => vagrant,
        source => 'puppet:///modules/profiles/pimpmylog/config',
        recurse => true
    }

    exec { 'install-pimpmylog':
        command => 'composer require potsky/pimp-my-log:1.7.* --no-interaction',
        cwd     => '/usr/share/pimpmylog',
        unless  => 'test -d /usr/share/pimpmylog/vendor',
        path    => ['/usr/local/bin', '/usr/bin'],
        user    => vagrant,
        environment => 'COMPOSER_HOME=/home/vagrant/.composer',
        require => [File['/usr/share/pimpmylog'], Anchor['php::end']]
    }

    exec { 'make-apache-logrotate-world-readable':
        command => 'sed -i \'s/apache2\/\*.log/apache2\/*log/g\' /etc/logrotate.d/apache2 && sed -i \'s/create [0-9]\+ root adm/create 644 root adm/g\' /etc/logrotate.d/apache2',
        unless  => 'grep "create 644 root adm" /etc/logrotate.d/apache2',
        require => Package['apache'],
        notify  => Service['apache']
    }

    exec { 'make-apache-logs-world-readable':
        command     => 'find /var/log/apache2 -exec chmod 644 {} \; && chmod +x /var/log/apache2',
        refreshonly => true,
        subscribe   => Exec['install-pimpmylog'],
        notify      => Service['apache'],
        require     => Package['apache']
    }

    exec { 'make-mysql-logs-world-readable':
        command => 'find /var/log/mysql -type f -exec chmod 644 {} \;',
        refreshonly => true,
        subscribe => Exec['install-pimpmylog'],
        notify  => Service['mysql']
    }

    exec { 'make-log-directories-world-readable':
        command => 'find /var/log -type d -exec chmod 755 {} \;',
        refreshonly => true,
        subscribe => Exec['install-pimpmylog'],
        notify  => [Service['apache'], Service['mysql']]
    }

    exec { 'make-system-logs-world-readable':
        command => 'chmod 644 /var/log/syslog',
        refreshonly => true,
        subscribe => Exec['install-pimpmylog'],
    }
}
