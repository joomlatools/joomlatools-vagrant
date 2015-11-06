# == Class: hhvm::repo::apt
#
# Configure apt repo
#
# === Parameters
#
# [*location*]
#   location of the apt repository
#
# [*release*]
#   release of the apt repository
#
# [*repos*]
#   apt repository names
#
# [*repo_key*]
#   location of the apt repository gpg key
#
# === Variables
#
# No variables
#
# === Examples
#
#  include hhvm::repo::apt
#
# === Authors
#
# Robin Gloster <robin.gloster@mayflower.de>
#
# === Copyright
#
# See LICENSE file
#
class hhvm::repo::apt(
  $location = 'http://dl.hhvm.com/ubuntu',
  $release  = 'trusty',
  $repos    = 'main',
  $repo_key = 'http://dl.hhvm.com/conf/hhvm.gpg.key',
) {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  apt::source { 'hhvm':
    location    => $location,
    release     => $release,
    repos       => $repos,
    include_src => false,
    key         => '1BE7A449',
    key_source  => 'http://dl.hhvm.com/conf/hhvm.gpg.key',
  }
}
