class profiles::box {

  require ::profiles::php

  include ::profiles::box::backup
  include ::profiles::box::scripts
  include ::profiles::box::tools
  include ::profiles::box::cli
  include ::profiles::box::phpmanager
  include ::profiles::box::cockpit

  file { '/etc/apache2/joomla.box-include.conf':
    content => template('profiles/apache/virtualhost/joomla.box.include.conf.erb')
  }

  ::apache::vhost { 'joomla.box-http':
    servername          => 'joomla.box',
    serveradmin         => 'webmaster@localhost',
    serveraliases       => 'localhost',
    port                => 80,
    priority            => '00',
    docroot             => '/var/www',
    override            => 'All',
    additional_includes => ['/etc/apache2/joomla.box-include.conf'],
    access_log_env_var  => '!dontlog',
    require             => File['/etc/apache2/joomla.box-include.conf']
  }

  ::apache::vhost { 'joomla.box-ssl':
    servername          => 'joomla.box',
    serveradmin         => 'webmaster@localhost',
    serveraliases       => 'localhost',
    port                => 443,
    ssl                 => true,
    ssl_cert            => '/etc/apache2/ssl/server.crt',
    ssl_key             => '/etc/apache2/ssl/server.key',
    priority            => '00',
    docroot             => '/var/www',
    override            => 'All',
    additional_includes => ['/etc/apache2/joomla.box-include.conf'],
    access_log_env_var  => '!dontlog',
    require             => File['/etc/apache2/joomla.box-include.conf']
  }

}