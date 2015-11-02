# == Class: openssl::packages
#
# Sets up packages for openssl
class openssl::packages {
  package { 'openssl':
    ensure => present,
  }

  if $::osfamily == 'Debian' {
    package { 'ca-certificates':
      ensure => present,
      before => Package['openssl'],
    }

    exec { 'update-ca-certificates':
      path        => $::path,
      refreshonly => true,
      require     => Package['ca-certificates'],
    }
  }
}
