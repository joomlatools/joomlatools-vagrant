# == Class: hhvm::config
#
# configure hhvm
#
# === Parameters
#
# No parameters
#
# === Variables
#
# No variables
#
# === Examples
#
#  include hhvm::config
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm::config (
  $user     = 'www-data',
  $group    = 'www-data',
  $port     = 9000,
  $settings = {}
) {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  validate_hash($settings)
  validate_string($user)
  validate_string($group)
  validate_string($port)

  $default_conf_file = '/etc/default/hhvm'
  create_resources(config::setting, to_hash_settings({
    'RUN_AS_USER' => $user,
    'RUN_AS_GROUP' => $group
  }, $default_conf_file), {
    file   => $default_conf_file,
    notify => Service['hhvm']
  })

  config::setting { 'hhvm-server-ini':
    file   => '/etc/hhvm/server.ini',
    key    => 'hhvm.server.port',
    value  => $port,
    notify => Service['hhvm']
  }

  $php_ini = '/etc/hhvm/php.ini'
  create_resources(config::setting, to_hash_settings($settings, $php_ini), {
    file   => $php_ini,
    notify => Service['hhvm']
  })
}
