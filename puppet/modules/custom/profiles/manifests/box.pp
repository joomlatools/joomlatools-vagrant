class profiles::box {

  require ::profiles::php

  include ::profiles::box::triggers
  include ::profiles::box::scripts
  include ::profiles::box::tools
  include ::profiles::box::cli
  include ::profiles::box::phpmanager

  apache::dotconf { 'joomla.box':
    enable  => false,
    content => template('profiles/apache/virtualhost/joomla.box.include.conf.erb'),
  }

  apache::vhost { 'joomla.box':
    server_admin  => 'webmaster@localhost',
    serveraliases => 'localhost',
    port          => 80,
    priority      => '00',
    docroot       => '/var/www',
    directory     => '/var/www',
    directory_allow_override   => 'All',
    directory_options => 'Indexes FollowSymLinks MultiViews',
    template      => 'profiles/apache/virtualhost/joomla.box.vhost.conf.erb',
    require       => Apache::Dotconf['joomla.box']
  }

}