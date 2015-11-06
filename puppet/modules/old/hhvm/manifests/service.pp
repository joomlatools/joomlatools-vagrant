# == Class: hhvm::service
#
# Start and control hhvm service
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm::service {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  service { 'hhvm':
    ensure    => 'running',
    enable    => true,
    hasstatus => true,
    require   => Package[$hhvm::package::package],
  }
}
