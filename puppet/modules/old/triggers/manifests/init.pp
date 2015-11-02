class triggers {

  file { '/home/vagrant/triggers':
    source => 'puppet:///modules/triggers/triggers',
    recurse => true,
    owner    => vagrant,
    group    => vagrant,
  }

  exec { 'make-triggers-executable':
    command   => 'chmod +x /home/vagrant/triggers/*',
    subscribe => File['/home/vagrant/triggers']
  }

}