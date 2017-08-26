class role::joomlatools inherits role {

  include ::profiles::apache
  include ::profiles::mysql

  include ::profiles::php
  include ::profiles::hhvm

  include ::profiles::rvm
  include ::profiles::nodejs

  include ::profiles::phpmyadmin
  include ::profiles::mailcatcher
  include ::profiles::webgrind

  include ::profiles::box

}