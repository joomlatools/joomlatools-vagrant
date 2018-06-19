class profiles::box::tools {

  Exec <| title == 'set-default-ruby-for-vagrant' |>
  ->
  exec {'install-capistrano-gem':
    user    => vagrant,
    command => 'bash -c "source ~/.rvm/scripts/rvm; gem install capistrano"',
    environment => ['HOME=/home/vagrant'],
    unless  => 'test -x /home/vagrant/.rvm/gems/ruby-2.2.6/bin/cap',
    timeout => 900,
  }
  ->
  exec {'install-bundler-gem':
    user    => vagrant,
    command => 'bash -c "source ~/.rvm/scripts/rvm; gem install bundler"',
    environment => ['HOME=/home/vagrant'],
    unless  => 'test -x /home/vagrant/.rvm/gems/ruby-2.2.6/bin/bundle',
    timeout => 900,
  }
  ->
  exec {'install-sass-gem':
    user    => vagrant,
    command => 'bash -c "source ~/.rvm/scripts/rvm; gem install sass compass"',
    environment => ['HOME=/home/vagrant'],
    unless  => 'test -x /home/vagrant/.rvm/gems/ruby-2.2.6/bin/sass',
    timeout => 900,
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

  apt::ppa { 'ppa:resmo/git-ftp': }

  package { 'git-ftp':
    require => Apt::Ppa['ppa:resmo/git-ftp']
  }

  package { 'httpie':
    ensure => latest
  }

  apt::ppa { 'ppa:tmate.io/archive': }

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