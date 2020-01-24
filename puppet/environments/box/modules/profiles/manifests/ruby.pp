class profiles::ruby(
  $version = '2.6.5'
) {

  Package <| title == 'git' |>
    -> Exec <| title == 'git-clone-rbenv' |>
    -> Rbenv::Plugin <| |>
    -> Rbenv::Gem <| |>

  Package <| title == 'git' |>
    -> Rbenv::Plugin <| |>

  class { '::rbenv': }

  rbenv::plugin { 'rbenv/ruby-build':
    latest  => true
  }

  rbenv::build { $version:
    global          => true,
    bundler_version => '>2.0'
  }

  file_line { 'add-gem-bin-dir-to-path':
    path    => '/home/vagrant/.bashrc',
    line    => "export PATH=/usr/local/rbenv/versions/${version}/bin:\$PATH"
  }

}