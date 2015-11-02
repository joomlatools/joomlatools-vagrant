# == Class: openssl
#
# Installs openssl and ensures bundled certificate list is world readable.
#
class openssl {
  class { '::openssl::packages': } ->
  class { '::openssl::config': } ->
  Class['openssl']
}
