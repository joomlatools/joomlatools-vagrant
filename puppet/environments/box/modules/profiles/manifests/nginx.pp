class profiles::nginx {

    package { ['nginx']:
        ensure => latest
    }

    service { 'nginx':
        ensure  => running,
        enable  => true,
        require => Package['nginx']
    }

    file { ['/etc/nginx/sites-available/conf.d', '/etc/nginx/sites-available', '/etc/nginx/sites-enabled']:
        purge   => true, # This is important: we want to make sure the sample vhosts are removed, as they run on port 80 by default!
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

    $vhosts = ['joomla.box', 'joomla.box-ssl']

    $vhosts.each |String $vhost| {
      file { "/etc/nginx/sites-available/${vhost}.conf":
        ensure  => file,
        owner   => vagrant,
        group   => vagrant,
        mode    => '0644',
        source  => "puppet:///modules/profiles/nginx/vhost/${vhost}.conf",
        notify  => Service['nginx'],
        require => Package['nginx']
      }

      file { "/etc/nginx/sites-enabled/${vhost}.conf":
        ensure  => link,
        target  => "/etc/nginx/sites-available/${vhost}.conf",
        notify  => Service['nginx']
      }
    }

}