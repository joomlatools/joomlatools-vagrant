class scripts {
  class {"scripts::install": }
}

class scripts::install {
  file { '/home/vagrant/scripts':
    source => 'puppet:///modules/scripts/scripts',
    recurse => true,
  }
  
  exec { 'make-scripts-executable': 
    command => 'chmod +x /home/vagrant/scripts/create_site',
    require => File['/home/vagrant/scripts']
  }

  exec { 'add-scripts-to-path':
    command => 'echo "export PATH=\$PATH:/home/vagrant/scripts" >> /home/vagrant/.profile',
    unless  => 'which create_site;echo $?',
    require => Exec['make-scripts-executable']
  }
}