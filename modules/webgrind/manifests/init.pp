class webgrind {

  file { "/tmp/webgrind.zip":
    source => "puppet:///modules/webgrind/webgrind-release-1.0.zip",
  }

  exec { 'php-extract-webgrind':
    cwd => '/var/www',
    command => "unzip /tmp/webgrind.zip",
    creates => '/var/www/webgrind',
  }
}