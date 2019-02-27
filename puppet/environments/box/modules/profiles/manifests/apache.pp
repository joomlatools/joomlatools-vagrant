class profiles::apache {

  include ::openssl

  file { ['/etc/apache2',  '/etc/apache2/ssl']:
    ensure => 'directory',
  }

  class { 'apache':
    package_ensure => latest,
    default_vhost  => true,
    purge_configs  => false,
    mpm_module     => 'prefork'
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
    require => Package['httpd']
  }

  apache::custom_config { 'custom':
    content       => template('profiles/apache/custom.conf.erb'),
    verify_config => false
  }

  class { 'apache::mod::rewrite': }
  class { 'apache::mod::ssl': }
  class { 'Apache::mod::proxy': }
  class { 'apache::mod::proxy_fcgi': }
  class { 'apache::mod::headers': }

  file { '/etc/apache2/conf-available/shared_paths.conf':
    ensure  => file,
    require => Package['httpd']
  }

  exec { 'enable-shared-paths-config':
    command => 'a2enconf shared_paths',
    unless  => 'test -L /etc/apache2/conf-enabled/shared_paths.conf',
    require => File['/etc/apache2/conf-available/shared_paths.conf']
  }

  file_line { 'set-env-for-debugging':
    path    => '/etc/apache2/apache2.conf',
    line    => "SetEnv JOOMLATOOLS_BOX ${::box_version}",
    match   => '^SetEnv JOOMLATOOLS_BOX [\d\.]+$',
    require => File['/etc/apache2/apache2.conf'],
    notify  => Service['httpd']
  }

}