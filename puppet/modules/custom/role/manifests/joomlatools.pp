class role::joomlatools inherits role {

  include ::profiles::apache
  include ::profiles::varnish

  include ::profiles::mysql

  include ::profiles::php
  include ::profiles::hhvm

  include ::profiles::rvm
  include ::profiles::nodejs

  include ::profiles::phpmyadmin
  include ::profiles::mailcatcher
  include ::profiles::webgrind
  include ::profiles::wetty
  include ::profiles::cloudcommander
  include ::profiles::pimpmylog

  include ::profiles::box

}