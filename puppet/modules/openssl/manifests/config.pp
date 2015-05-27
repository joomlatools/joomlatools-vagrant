# == Class: openssl::config
#
# Deploys configuration for OpenSSL
#
class openssl::config {
  include ::openssl::params

  file { 'ca-certificates.crt':
    ensure => 'present',
    owner  => 'root',
    mode   => '0644',
    path   => $openssl::params::ca_cert_path,
  }
}
