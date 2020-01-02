class profiles::ruby(
  $version = '2.6.5'
) {

  class { '::rbenv': }

  rbenv::plugin { 'rbenv/ruby-build':
    latest => true
  }

  rbenv::build { $version:
    global => true
  }

  file_line { 'add-gem-bin-dir-to-path':
    path    => '/home/vagrant/.bashrc',
    line    => "export PATH=/usr/local/rbenv/versions/${version}/bin:\$PATH"
  }

}