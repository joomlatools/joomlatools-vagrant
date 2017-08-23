class profiles::box {

  require ::profiles::php

  include ::profiles::box::triggers
  include ::profiles::box::scripts
  include ::profiles::box::tools
  include ::profiles::box::cli
  # include ::profiles::box::phpmanager

}