class profiles::box {

  require ::profiles::php

  include ::profiles::box::backup
  include ::profiles::box::scripts
  include ::profiles::box::tools
  include ::profiles::box::cli
  include ::profiles::box::phpmanager

  file { '/etc/apache2/joomla.box-include.conf':
    content => template('profiles/apache/virtualhost/joomla.box.include.conf.erb')
  }

  ::apache::vhost { 'joomla.box':
    serveradmin         => 'webmaster@localhost',
    serveraliases       => 'localhost',
    port                => 80,
    priority            => '00',
    docroot             => '/var/www',
    override            => 'All',
    additional_includes => ['/etc/apache2/joomla.box-include.conf'],
    require             => File['/etc/apache2/joomla.box-include.conf']
  }

}