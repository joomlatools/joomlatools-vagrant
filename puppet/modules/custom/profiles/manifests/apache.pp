class profiles::apache {

  include ::openssl
  include ::apache

  file { ['/etc/apache2',  '/etc/apache2/ssl']:
    ensure => 'directory',
  }

  openssl::certificate::x509 { 'server':
    country      => 'BE',
    organization => 'Joomlatools',
    commonname   => 'localhost.ssl',
    email        => 'info@joomlatools.com',
    days         => 3650,
    base_dir     => '/etc/apache2/ssl',
    require      => File['/etc/apache2/ssl']
  }

  exec { 'apache-set-servername':
    command => "echo \"ServerName joomlatools\" > /etc/apache2/conf-available/fqdn.conf; a2enconf fqdn",
    path    => ['/usr/bin' , '/bin', '/usr/sbin/'],
    creates => '/etc/apache2/conf-available/fqdn',
    unless  => 'grep "ServerName joomlatools" /etc/apache2/conf-enabled/fqdn.conf',
    require => Class['::apache']
  }

  apache::dotconf { 'custom':
    content => template('profiles/apache/custom.conf.erb'),
  }

  apache::module { 'rewrite': }
  apache::module { 'ssl': }
  apache::module { 'proxy_fcgi': }
  apache::module { 'headers': }

  $apache_hhvm_proxy = "
<FilesMatch \\.php$>
  SetHandler \"proxy:fcgi://127.0.0.1:9000\"
</FilesMatch>"

  file { '/etc/apache2/conf-available/hhvm.conf':
    ensure  => file,
    content => $apache_hhvm_proxy,
    require => Class['::apache']
  }

  exec { 'disable-default-vhost':
    command => 'a2dissite 000-default',
    onlyif  => 'test -L /etc/apache2/sites-enabled/000-default.conf',
  }

  file { '/etc/apache2/conf-available/shared_paths.conf':
    ensure => file
  }

  exec { 'enable-shared-paths-config':
    command => 'a2enconf shared_paths',
    unless  => 'test -L /etc/apache2/conf-enabled/shared_paths.conf',
    require => File['/etc/apache2/conf-available/shared_paths.conf']
  }

  exec { 'set-env-for-debugging':
    command => "echo \"\nSetEnv JOOMLATOOLS_BOX ${::box_version}\" >> /etc/apache2/apache2.conf",
    unless  => 'grep JOOMLATOOLS_BOX /etc/apache2/apache2.conf',
    notify  => Service['apache']
  }

}