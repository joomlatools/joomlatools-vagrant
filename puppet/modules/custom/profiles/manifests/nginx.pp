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
        recurse => true,
        require => Package['nginx'],
        notify  => Service['nginx'],
        before  => [File['/etc/nginx/sites-available/joomla.box.conf'], File['/etc/nginx/sites-enabled/joomla.box.conf']]
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

    file { '/etc/nginx/php.conf':
      ensure  => file,
      owner   => vagrant,
      group   => vagrant,
      mode    => '0644',
      source  => 'puppet:///modules/profiles/nginx/php.conf',
      notify  => Service['nginx'],
      require => Package['nginx']
    }

    file { '/etc/nginx/sites-available/joomla.box.conf':
      ensure  => file,
      owner   => vagrant,
      group   => vagrant,
      mode    => '0644',
      source  => 'puppet:///modules/profiles/nginx/vhost/joomla.box.conf',
      notify  => Service['nginx'],
      require => Package['nginx']
    }

    file { '/etc/nginx/sites-enabled/joomla.box.conf':
      ensure  => link,
      target  => '/etc/nginx/sites-available/joomla.box.conf',
      notify  => Service['nginx']
    }

}