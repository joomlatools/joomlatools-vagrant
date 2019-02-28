class profiles::box::tools {

  exec {'install-capistrano-gem':
    user    => vagrant,
    command => '/usr/bin/gem install --user-install  --no-ri --no-rdoc capistrano',
    environment => ['HOME=/home/vagrant'],
    unless  => 'test -x /home/vagrant/.gem/ruby/2.5.0/bin/cap',
    path    => ['/usr/bin/', '/bin/', '/home/vagrant/.gem/ruby/2.5.0/bin/'],
    timeout => 900,
    tag     => ['rubygem']
  }

  exec {'install-bundler-gem':
    user    => vagrant,
    command => 'gem install --user-install  --no-ri --no-rdoc bundler',
    environment => ['HOME=/home/vagrant'],
    unless  => 'test -x /home/vagrant/.gem/ruby/2.5.0/bin/bundle',
    path    => ['/usr/bin/', '/bin/', '/home/vagrant/.gem/ruby/2.5.0/bin/'],
    timeout => 900,
    tag     => ['rubygem']
  }

  exec {'install-sass-gem':
    user    => vagrant,
    command => '/usr/bin/gem install --user-install  --no-ri --no-rdoc sass compass',
    environment => ['HOME=/home/vagrant'],
    unless  => 'test -x /home/vagrant/.gem/ruby/2.5.0/bin/sass',
    path    => ['/usr/bin/', '/bin/', '/home/vagrant/.gem/ruby/2.5.0/bin/'],
    timeout => 900,
    tag     => ['rubygem']
  }

  exec { 'npm-install-yarn':
    command => 'npm install -g yarn',
    unless  => 'which yarn',
    require => Package['nodejs']
  }

  exec { 'npm-install-uglify-js':
    command => 'npm install -g uglify-js@1',
    unless  => 'which uglifyjs',
    require => Package['nodejs']
  }

  exec { 'npm-install-less':
    command => 'npm install -g less',
    unless  => 'which lessc',
    require => Package['nodejs'],
  }

  exec { 'npm-install-autoless':
    command => 'npm install -g autoless',
    unless  => 'which autoless',
    require => Package['nodejs'],
  }

  package { 'git-ftp':
    ensure => latest
  }

  package { 'httpie':
    ensure => latest
  }

  package { 'tmate':
    ensure => latest
  }

  file { '/usr/share/phpmetrics':
    ensure => directory,
    owner  => vagrant
  }

  exec {'install-phpmetrics':
    command => 'composer require halleck45/phpmetrics --no-interaction',
    path    => ['/usr/bin' , '/bin', '/usr/local/bin'],
    cwd     => '/usr/share/phpmetrics',
    unless  => 'test -d /usr/share/phpmetrics/vendor/halleck45',
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer',
    require => [File['/usr/share/phpmetrics'], Anchor['php::end']]
  }

  exec { 'add-phpmetrics-to-path':
    command => 'echo "export PATH=\$PATH:/usr/share/phpmetrics/vendor/bin" >> /home/vagrant/.bash_profile',
    unless  => 'grep ":/usr/share/phpmetrics/vendor/bin" /home/vagrant/.bash_profile',
    user    => vagrant,
    require => Exec['install-phpmetrics']
  }

  exec { 'install-phing':
    command     => '/usr/local/bin/composer global require phing/phing:">=3.0.0-alpha1" --no-interaction',
    creates     => "/home/vagrant/.composer/vendor/phing/phing",
    user        => vagrant,
    environment => "COMPOSER_HOME=/home/vagrant/.composer",
    require     => Anchor['php::end']
  }

}