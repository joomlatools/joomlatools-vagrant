class webgrind {

  file { "/tmp/webgrind.zip":
    source => "puppet:///modules/webgrind/webgrind-release-1.0.zip",
  }

  exec { 'php-extract-webgrind':
    cwd => '/usr/share',
    command => "unzip /tmp/webgrind.zip",
    creates => '/usr/share/webgrind',
  }
}