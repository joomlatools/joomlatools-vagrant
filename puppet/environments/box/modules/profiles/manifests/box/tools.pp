class profiles::box::tools {

  exec {'install-capistrano-gem':
    user    => vagrant,
    command => '/usr/bin/gem install --user-install --no-ri --no-rdoc capistrano',
    environment => ['HOME=/home/vagrant'],
    unless  => 'test -x /home/vagrant/.gem/ruby/2.5.0/bin/cap',
    path    => ['/usr/bin/', '/bin/', '/home/vagrant/.gem/ruby/2.5.0/bin/'],
    timeout => 900,
    tag     => ['rubygem']
  }

  exec {'install-bundler-gem':
    user    => vagrant,
    command => 'gem install --user-install --no-ri --no-rdoc bundler',
    environment => ['HOME=/home/vagrant'],
    unless  => 'test -x /home/vagrant/.gem/ruby/2.5.0/bin/bundle',
    path    => ['/usr/bin/', '/bin/', '/home/vagrant/.gem/ruby/2.5.0/bin/'],
    timeout => 900,
    tag     => ['rubygem']
  }

  exec {'install-sass-gem':
    user    => vagrant,
    command => '/usr/bin/gem install --user-install --no-ri --no-rdoc sass compass',
    environment => ['HOME=/home/vagrant'],
    unless  => 'test -x /home/vagrant/.gem/ruby/2.5.0/bin/sass',
    path    => ['/usr/bin/', '/bin/', '/home/vagrant/.gem/ruby/2.5.0/bin/'],
    timeout => 900,
    tag     => ['rubygem']
  }

  package { ['yarn', 'less', 'autoless', 'uglify-js']:
    ensure   => present,
    provider => 'npm',
  }

  package { [
    'libjpeg-dev',
    'libfontconfig'
  ]:
    ensure  => latest
  }

  exec { 'npm install yellowlabtools' :
    command => 'npm install -g yellowlabtools --unsafe-perm=true --allow-root',
    path => ['/usr/bin']
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
    command => 'echo "export PATH=\$PATH:/usr/share/phpmetrics/vendor/bin" >> /home/vagrant/.bashrc',
    unless  => 'grep ":/usr/share/phpmetrics/vendor/bin" /home/vagrant/.bashrc',
    user    => vagrant,
    require => Exec['install-phpmetrics']
  }

  exec { 'install-phing':
    command     => '/usr/local/bin/composer global require phing/phing:"2.*" --no-interaction',
    creates     => "/home/vagrant/.composer/vendor/phing/phing",
    user        => vagrant,
    environment => "COMPOSER_HOME=/home/vagrant/.composer",
    require     => Anchor['php::end']
  }

  archive { '/tmp/ngrok.zip':
    source       => 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip',
    extract      => true,
    extract_path => '/usr/local/bin',
    creates      => "/usr/local/bin/ngrok",
  }
}