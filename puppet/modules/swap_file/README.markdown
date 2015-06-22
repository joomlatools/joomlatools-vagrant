####Table of Contents

1. [Overview](#overview)
2. [Module Description ](#module-description)
3. [Setup](#setup)
    * [What swap_file affects](#what-swap_file-affects)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [Development](#development)

##Overview

Manage [swap files](http://en.wikipedia.org/wiki/Paging) for your Linux environments. This is based on the gist by @Yggdrasil, with a few changes and added specs.

##Setup

###What swap_file affects

* Creating files from the path given using `/bin/dd`
* Swapfiles on the system
* Any mounts of swapfiles

##Usage

The simplest use of the module is this:

```puppet
swap_file::files { 'default':
  ensure   => present,
}
```

By default, the module it will:

* create a file using /bin/dd atr `/mnt/swap.1` with the default size taken from the `$::memorysizeinbytes`
* A `mount` for the swapfile created

For a custom setup, you can do something like this:

```puppet
swap_file::files { 'tmp file swap':
  ensure   => present,
  swapfile => '/tmp/swapfile',
  mount    => false,
}
```

To remove a prexisting swap, you can use ensure absent:

```puppet
swap_file::files { 'tmp file swap':
  ensure   => absent,
}
```

## Previous to 1.0.1 Release

Previously you would create swapfiles with the `swap_file` class:

```
class { 'swap_file':
   swapfile => '/mount/swapfile',
   swapfilesize => '100 MB',
}
```

However, this had many problems, such as not being able to declare more than one swap_file because of duplicate class errors.

This is now deprecated and will give a warning. 

##Limitations

Primary support is for Debian and RedHat, but should work on all Linux flavours.

Right now there is no BSD support, but I'm planning on adding it in the future

##Development

Follow the CONTRIBUTING guidelines! :)
