class role::joomlatools inherits role {

  include ::profiles::apache
  include ::profiles::php
  include ::profiles::mysql

  include ::profiles::rvm

  include ::profiles::phpmyadmin

}