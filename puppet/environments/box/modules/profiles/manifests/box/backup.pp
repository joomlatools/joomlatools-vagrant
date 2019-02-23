class profiles::box::backup {

  file { '/home/vagrant/backup':
    source => 'puppet:///modules/profiles/box/backup',
    recurse => true,
    mode    => 0755,
    owner   => vagrant,
    group   => vagrant,
  }

}