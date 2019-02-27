class profiles::ruby {

  Package <| tag == 'ruby' |>
    -> Exec <| tag == 'rubygem' |>

  package { 'ruby':
    ensure => '1:2.5.1',
    tag    => ['ruby']
  }

  package { 'ruby-dev':
    ensure => installed,
    tag    => ['ruby']
  }

  file_line { 'add-gem-bin-dir-to-path':
    path    => '/home/vagrant/.bash_profile',
    line    => 'export PATH=$PATH:/home/vagrant/.gem/ruby/2.5.0/bin/'
  }

}