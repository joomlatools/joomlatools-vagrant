# == hhvm::pgsql
#
# installs hhvm pgsql extension
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm::pgsql {
  ensure_packages('libpq5')

  Package['libpq5'] ->
  wget::fetch { 'http://glob.in/pgsql.so':
    destination => '/usr/lib/hhvm/pgsql.so',
    timeout     => 0,
    verbose     => false,
  } ->
  ini_setting { 'hhvm-add-hdf':
    path    => '/etc/default/hhvm',
    section => '',
    setting => 'ADDITIONAL_ARGS',
    value   => '\'--config /etc/hhvm/server.hdf\'',
    notify  => Service['hhvm']
  } ->
  ini_setting { 'hhvm-server-ini-extension':
    path    => '/etc/hhvm/server.ini',
    section => '',
    setting => 'hhvm.dynamic_extension_path',
    value   => '/usr/lib/hhvm',
    notify  => Service['hhvm']
  } ->
  file { '/etc/hhvm/server.hdf':
    ensure  => present,
    content => '
DynamicExtensions {
    * = pgsql.so
}
',
    notify  => Service['hhvm']
  }
}
