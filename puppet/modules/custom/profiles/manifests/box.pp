class profiles::box {

  require ::profiles::php

  include ::profiles::box::triggers
  include ::profiles::box::scripts
  include ::profiles::box::tools
  include ::profiles::box::cli
  # include ::profiles::box::phpmanager

  apache::vhost { 'joomla.box':
    server_admin  => 'webmaster@localhost',
    serveraliases => 'localhost',
    port          => 8080,
    priority      => '00',
    docroot       => '/var/www',
    directory     => '/var/www',
    directory_allow_override   => 'All',
    directory_options => 'Indexes FollowSymLinks MultiViews',
    template     => 'profiles/apache/virtualhost/joomlatools.vhost.conf.erb',
  }

}