class role::joomlatools inherits role {

  include profiles::base

  include profiles::apache
  include profiles::php
  include profiles::mysql

}