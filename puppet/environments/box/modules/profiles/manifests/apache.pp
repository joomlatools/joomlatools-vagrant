class profiles::apache {

  include ::openssl

  file { ['/etc/apache2',  '/etc/apache2/ssl']:
    ensure => 'directory',
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

  class { '::apache':
    package_ensure => latest,
    default_vhost  => false,
    purge_configs  => false,
    mpm_module     => 'prefork',
    require        => Openssl::Certificate::X509['server']
  }

  class { 'apache::mod::expires': }
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

  ::apache::custom_config { 'cache-control':
    source        => "puppet:///modules/profiles/apache/cache-control.conf",
    verify_config => false
  }

  # The puppetlabs/apache module relies on the conf.d directory instead of conf-available/conf-enable.
  # The latter however are created by default by the Apache2 package on Ubuntu, so we want to
  # make sure they're removed to avoid confusion.
  #
  # Also see: https://github.com/puppetlabs/puppetlabs-apache/pull/1851#issuecomment-452732192
  file { ['/etc/apache2/conf-available', '/etc/apache2/conf-enabled']:
    ensure  => absent,
    recurse => true,
    purge   => true,
    force   => true
  }
}