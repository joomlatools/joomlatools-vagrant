# == Class: hhvm
#
# Installs and configures HHVM in a sane kind of way
#
# === Parameters
#
# Document parameters here.
#
# [*manage_repos*]
#   Defines if this module should manage the repository for HHVM
#
# === Examples
#
#  class { hhvm: }
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm (
  $manage_repos = true,
  $pgsql        = false,
) {

  validate_bool($manage_repos)

  if $manage_repos {
    anchor { 'hhvm::repo': } ->
      class { 'hhvm::repo': } ->
    Anchor['hhvm::begin']
  }

  anchor { 'hhvm::begin': } ->
    class { 'hhvm::package': } ->
    class { 'hhvm::config': } ->
    class { 'hhvm::service': } ->
  anchor { 'hhvm::end': }

  if $pgsql {
    Class['hhvm::package'] ->
    class { 'hhvm::pgsql': } ->
    Class['hhvm::service']
  }
}
