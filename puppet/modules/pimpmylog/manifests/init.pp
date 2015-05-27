class pimpmylog {

    file { '/usr/share/pimpmylog':
        ensure => present,
        owner  => vagrant,
        group  => vagrant,
        source => 'puppet:///modules/pimpmylog/config',
        recurse => true
    }

    exec { 'install-pimpmylog':
        command => 'composer require potsky/pimp-my-log:1.7.* --no-interaction',
        cwd     => '/usr/share/pimpmylog',
        unless  => '[ -d /usr/share/pimpmylog/vendor ]',
        path    => '/usr/bin',
        user    => vagrant,
        require => File['/usr/share/pimpmylog']
    }

    exec { 'make-apache-logs-world-readable':
        command => 'sed -i \'s/create [0-9]\+ root adm/create 644 root adm/g\' /etc/logrotate.d/apache2'
    }

    exec { 'make-log-directories-world-readable':
        command => 'find /var/log -type d -exec chmod 755 {} \; && find /var/log/apache2 -type f -exec chmod 644 {} \; '
    }
}
