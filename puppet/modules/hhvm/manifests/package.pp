# == Class: hhvm::package
#
# Install hhvm
#
# === Parameters
#
# [*package*]
#   The package name for hhvm
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm::package(
  $package = 'hhvm'
) {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  validate_string($package)

  package { $package:
    ensure => 'installed',
  }
}
