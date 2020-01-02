class profiles::box::tools {

  rbenv::gem { ['capistrano', 'sass']:
    ruby_version => $::profiles::ruby::version,
    skip_docs    => true,
    timeout      => 900
  }

  package { ['yarn', 'less', 'autoless', 'uglify-js']:
    ensure   => present,
    provider => 'npm',
  }

  package { [
    'libjpeg-dev',
    'libfontconfig1'
  ]:
    ensure  => latest,
    before  => Package['yellowlabtools']
  }

  package { 'yellowlabtools':
    provider => 'npm',
    install_options => ['--unsafe-perm=true', '--allow-root']
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