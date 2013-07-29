class scripts {
  class {"scripts::install": }
}

class scripts::install {
  file { '/home/vagrant/scripts':
    source => 'puppet:///modules/scripts/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant,
  }
  
  exec { 'make-scripts-executable': 
    command => 'chmod +x /home/vagrant/scripts/sitemanager; chmod +x /home/vagrant/scripts/symlinker',
    require => File['/home/vagrant/scripts']
  }

  exec { 'add-scripts-to-path':
    command => 'echo "export PATH=\$PATH:/home/vagrant/scripts" >> /home/vagrant/.profile',
    unless  => 'which sitemanager;echo $?',
    require => Exec['make-scripts-executable']
  }
}