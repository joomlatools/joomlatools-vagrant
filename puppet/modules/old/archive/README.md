Archive Puppet Module
====================

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/camptocamp/archive.svg)](https://forge.puppetlabs.com/camptocamp/archive)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/camptocamp/archive.svg)](https://forge.puppetlabs.com/camptocamp/archive)
[![Build Status](https://img.shields.io/travis/camptocamp/puppet-archive/master.svg)](https://travis-ci.org/camptocamp/puppet-archive)
[![Gemnasium](https://img.shields.io/gemnasium/camptocamp/puppet-archive.svg)](https://gemnasium.com/camptocamp/puppet-archive)
[![By Camptocamp](https://img.shields.io/badge/by-camptocamp-fb7047.svg)](http://www.camptocamp.com)

Overview
--------

Puppet Module to download and extract tar and zip archives based on [camptocamp/puppet-archive](https://github.com/camptocamp/puppet-archive).

Supported archive types are:

- `tar.gz`, `tgz`
- `tar.bz2`, `tbz2`
- `tar.xz`, `txz`
- `zip`

Features:

- Ability to follow redirects
- Supports checksum matching

Usage
-----

Example:

    archive { 'apache-tomcat-6.0.26':
      ensure => present,
      url    => 'http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.26/bin/apache-tomcat-6.0.26.tar.gz',
      target => '/opt',
    }

You can have archive follow redirects by setting:

```
follow_redirects => true
````

The default archive format is ```tar.gz```. To use another supported format you must specify the extenstion:

```
extension => "zip"
```

By default archive will try and find a matching checksum file to verify the download. To disable this behavior set the ```checksum``` option to ```false```:

```
checksum => false
```

You can specify a ```digest_url```, ```digest_string``` and ```digest_type``` to verify archive integrity.

For `.tar.gz` and `tar.bz2` archives, the extract step's `--strip-components=n` flag can be accessed. This can be used to [change the name of the extracted directory](http://unix.stackexchange.com/questions/11018/how-to-choose-directory-name-during-untarring).

```
strip_components => 1
```

```
purge_target => false
```

By default the target directory is left intact, this option can be used to `rm -rf` the target directory prior to extraction.

This full example will download the [packer](packer.io) tool to ```/usr/local/bin```:

```
archive { '0.5.1_linux_amd64':
   ensure => present,
   url => 'https://dl.bintray.com/mitchellh/packer/0.5.1_linux_amd64.zip',
   target => '/usr/local/bin',
   follow_redirects => true,
   extension => 'zip',
   checksum => false,
   src_target => '/tmp'
}
```

You can also specifiy a global user to be used for the whole download and extract operation. Note that the module doesn't handle the right of the specified user on the src_target directory.
```

archive { '0.5.1_linux_amd64':
   ensure => present,
   url => 'https://dl.bintray.com/mitchellh/packer/0.5.1_linux_amd64.zip',
   target => '/usr/local/bin',
   follow_redirects => true,
   extension => 'zip',
   checksum => false,
   user       => 'camptocamp',
   src_target => '/home/camptocamp'
}
```

License
-------

Copyright (c) 2012 Camptocamp SA

This script is licensed under the Apache License, Version 2.0.

See http://www.apache.org/licenses/LICENSE-2.0.html for the full license text.


Support
-------

Please log tickets and issues at our [project site](https://github.com/camptocamp/puppet-archive/issues).
