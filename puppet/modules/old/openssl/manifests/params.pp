# == Class: openssl::params
#
# Sets parameters for openssl
#
class openssl::params {
  case $::osfamily {
    'Debian': {
      $ca_cert_path = '/etc/ssl/certs/ca-certificates.crt'
    }

    'RedHat': {
      $ca_cert_path = $::operatingsystemmajrelease ? {
        '4'     => '/usr/share/ssl/certs/ca-bundle.crt',
        default => '/etc/pki/tls/certs/ca-bundle.crt',
      }
    }

    default: {
      fail "Unknown OS family '${::osfamily}'"
    }
  }
}
