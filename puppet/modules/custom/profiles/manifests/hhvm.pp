class profiles::hhvm {

  class { '::hhvm':
    manage_repos => true,
    pgsql        => false
  }

}