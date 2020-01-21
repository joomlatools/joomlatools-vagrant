class profiles::pimpmylog {

    require ::profiles::apache
    require ::profiles::mysql

    file { '/usr/share/pimpmylog':
        ensure => directory,
        owner  => vagrant,
        group  => vagrant,
    }

    exec { 'install-pimpmylog':
        command => 'composer create-project potsky/pimp-my-log:1.7.14 /usr/share/pimpmylog/ --no-interaction',
        cwd     => '/usr/share/pimpmylog',
        unless  => 'test -d /usr/share/pimpmylog/vendor',
        path    => ['/usr/local/bin', '/usr/bin'],
        user    => vagrant,
        timeout => 3600,
        environment => 'COMPOSER_HOME=/home/vagrant/.composer',
        require => [File['/usr/share/pimpmylog'], Anchor['php::end']]
    }

    file { '/usr/share/pimpmylog/config.user.json':
        ensure => file,
        owner  => vagrant,
        group  => vagrant,
        source => 'puppet:///modules/profiles/pimpmylog/config/config.user.json',
        require => Exec['install-pimpmylog']
    }

    file { '/usr/share/pimpmylog/config.user.d':
        ensure  => file,
        owner   => vagrant,
        group   => vagrant,
        source  => 'puppet:///modules/profiles/pimpmylog/config/config.user.d',
        recurse => true,
        require => Exec['install-pimpmylog']
    }

    exec { 'make-apache-logrotate-world-readable':
        command => 'sed -i \'s/apache2\/\*.log/apache2\/*log/g\' /etc/logrotate.d/apache2 && sed -i \'s/create [0-9]\+ root adm/create 644 root adm/g\' /etc/logrotate.d/apache2',
        unless  => 'grep "create 0644 root adm" /etc/logrotate.d/apache2',
        require => Package['httpd'],
        notify  => Service['httpd']
    }

    exec { 'make-log-directories-world-readable':
        command => 'find /var/log -type d -exec chmod 0755 {} \;',
        refreshonly => true,
        subscribe => Exec['install-pimpmylog'],
        notify  => [Service['httpd'], Service['mysql']]
    }

    file { '/var/log/apache2/':
      ensure  => directory,
      recurse => true,
      owner   => root,
      group   => adm,
      mode    => '0644'
    }

    file { '/var/log/mysql/':
      ensure  => directory,
      recurse => true,
      owner   => mysql,
      group   => adm,
      mode    => '0644'
    }

}
