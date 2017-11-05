class profiles::box::cli {

  file { '/home/vagrant/box':
    source => 'puppet:///modules/profiles/box/cli/scripts',
    recurse => true,
    owner    => vagrant,
    group    => vagrant
  }

  exec { 'fetch-box-dependencies':
    command => 'composer require symfony/console:2.7.* stecman/symfony-console-completion --no-interaction',
    cwd     => '/home/vagrant/box',
    unless  => 'test -d /home/vagrant/box/vendor/symfony',
    path    => ['/usr/local/bin', '/usr/bin'],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer',
    require => [Anchor['php::end'], File['/home/vagrant/box']]
  }

  exec { 'make-box-executable':
    command => 'chmod +x /home/vagrant/box/box',
    unless  => 'test -x /home/vagrant/box/box',
    require => File['/home/vagrant/box']
  }

  exec { 'add-box-to-path':
    command => 'echo "export PATH=\$PATH:/home/vagrant/box" >> /home/vagrant/.bash_profile',
    unless  => 'grep ":/home/vagrant/box" /home/vagrant/.bash_profile',
    require => Exec['make-box-executable']
  }

  file_line { 'register-box-autocompletion':
    path    => '/home/vagrant/.bash_profile',
    line    => 'source <(/home/vagrant/box/box _completion --generate-hook --program=box) 2> /dev/null',
    require => File['/home/vagrant/.bash_profile']
  }

  package {'bash-completion':
    ensure => installed
  }

}