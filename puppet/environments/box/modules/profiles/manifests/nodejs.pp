class profiles::nodejs {

  class { '::nvm':
    user         => 'vagrant',
    install_node => '10.15.3',
  }

}