# hhvm

[![Build Status](https://travis-ci.org/mayflower/puppet-hhvm.svg?branch=master)](https://travis-ci.org/mayflower/puppet-hhvm)

#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with hhvm](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hhvm](#beginning-with-hhvm)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

This module installs and configures Facebook's HHVM for you. It aims to use sane defaults and be easily configurable with hiera.

## Dependencies

HHVM depends on
 * puppetlabs/stdlib
 * puppetlabs/apt for the repository configureation
 * maestrodev/wget for the highly experimental pgsql support.

## Usage

To use the module simply use the base class which will do everything you need. You may turn off repo management or use the **highly experimental** pgsql support.
```puppet
class { '::hhvm':
  manage_repos => true,
  pgsql        => false
}
```

Additional configs (with defaults):
```yaml
hhvm::config::user: www-data   # user to run server with
hhvm::config::group: www-data  # group to run server with
hhvm::config::port: 9000       # port for fastcgi server
hhvm::config::settings: []     # augeas commands for php.ini
```

Example config:
```yaml
hhvm::config::user: vagrant
hhvm::config::group: users
hhvm::config::port: 9090
hhvm::config::settings:
  - set .anon/date.timezone Europe/Berlin
```

## Limitations

Currently only tested with Ubuntu 14.04 Trusty Tahr

## Development

 *  If you find a bug or wish to have a new feature simply open an issue.
 *  Otherwise if you are really motivated pull requests are always welcome, too.

## Credits
 * Created by [Robin Gloster](https://github.com/globin)
