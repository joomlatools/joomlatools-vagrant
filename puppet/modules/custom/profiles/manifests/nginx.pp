class profiles::nginx {

    apt::ppa { 'ppa:vshn/nginx': }

    package { ['nginx', 'nginx-extras', 'ngx-pagespeed']:
        ensure => latest
    }

    service { 'nginx':
        ensure  => running,
        require => [Package['nginx'], Package['ngx-pagespeed']]
    }

    file { ['/etc/nginx/sites-available/conf.d', '/etc/nginx/sites-available', '/etc/nginx/sites-enabled']:
        purge   => true,
        recurse => true,
        require => Package['nginx'],
        notify  => Service['nginx']
    }

    user { 'nginx':
        ensure => present,
        gid    => nginx,
        shell  => '/bin/false',
        home   => '/nonexistent'
    }

    group { 'nginx':
        ensure => present
    }

}