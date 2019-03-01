class profiles::apache {

  include ::openssl

  file { ['/etc/apache2',  '/etc/apache2/ssl']:
    ensure => 'directory',
  }

  class { '::apache':
    package_ensure => latest,
    default_vhost  => true,
    purge_configs  => false,
    mpm_module     => 'prefork'
  }

  ::openssl::certificate::x509 { 'server':
    country      => 'BE',
    organization => 'Joomlatools',
    commonname   => 'localhost.ssl',
    email        => 'info@joomlatools.com',
    days         => 3650,
    base_dir     => '/etc/apache2/ssl',
    require      => File['/etc/apache2/ssl']
  }

  class { 'apache::mod::rewrite': }
  class { 'apache::mod::ssl': }
  class { 'apache::mod::proxy': }
  class { 'apache::mod::proxy_http': }
  class { 'apache::mod::proxy_fcgi': }
  class { 'apache::mod::headers': }

  ::apache::custom_config { 'custom':
    content       => template('profiles/apache/custom.conf.erb'),
    verify_config => false
  }

  ::apache::custom_config { 'shared_paths':
    content       => '',
    verify_config => false
  }

}