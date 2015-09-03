# Class: swap_file
#
# This class creates a swapspace on a node.
#
# Using this class is now deprecated, use the swap_file::files defined type
#
# == Parameters
# [*ensure*]
#   Allows creation or removal of swapspace and the corresponding file.
# [*swapfile*]
#   Location of swapfile, defaults to /mnt
# [*swapfilesize*]
#   Size of the swapfile as a string (eg. 10 MB, 1.2 GB).
#   Defaults to $::memorysize fact on the node
# [*add_mount*]
#   Add a mount to the swapfile so it persists on boot
# [*options*]
#   Mount options for the swapfile
#
# == Examples
#
#   include swap_file
#
#   class { 'swap_file':
#     ensure => present,
#   }
#
#   class { 'swap_file':
#     swapfile => '/mount/swapfile',
#     swapfilesize => '100 MB',
#   }
#
# == Authors
#    @petems - Peter Souter
#    @Yggdrasil
#
class swap_file (
  $ensure        = 'present',
  $swapfile      = '/mnt/swap.1',
  $swapfilesize  = $::memorysize,
  $add_mount     = true,
  $options       = 'defaults'
) inherits swap_file::params {

  # Parameter validation
  validate_re($ensure, ['^absent$', '^present$'], "Invalid ensure: ${ensure} - (Must be 'present' or 'absent')")
  validate_string($swapfile)
  $swapfilesize_mb = to_bytes($swapfilesize) / 1000000
  validate_bool($add_mount)

  warning('Use of swap_file class is now deprecated')
  warning('Use the swap_file::files defined type (Or downgrade the swap_file module to 1.0.1')

  if $ensure == 'present' {
    ::swap_file::files{ $swapfile:
      ensure       => 'present',
      swapfile     => $swapfile,
      swapfilesize => $swapfilesize,
      add_mount    => $add_mount,
      options      => $options,
    }
  }
  elsif $ensure == 'absent' {
    ::swap_file::files{ $swapfile:
      ensure        => 'absent',
    }
  }
}
