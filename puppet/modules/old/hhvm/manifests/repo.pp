# == Class: hhvm::repo
#
# Configure package repository
#
# === Parameters
#
# No parameters
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm::repo {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  anchor { 'hhvm::repo::begin': } ->
  anchor { 'hhvm::repo::end': }

  case $::osfamily {
    'Debian': {

      # FIXME use correct urls for different Debian variants/versions
      # see https://github.com/facebook/hhvm/wiki/Prebuilt%20Packages%20for%20HHVM
      include hhvm::repo::apt
    }
    default: {
      fail("No repo available for ${::osfamily}/${::operatingsystem}, please fork this module and add one in repo.pp")
    }
  }
}
