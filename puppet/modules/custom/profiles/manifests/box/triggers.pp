class profiles::box::triggers {

  file { '/home/vagrant/triggers':
    source => 'puppet:///modules/profiles/box/triggers',
    recurse => true,
    mode    => 0755,
    owner   => vagrant,
    group   => vagrant,
  }

}