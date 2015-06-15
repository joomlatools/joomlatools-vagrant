single_user_rvm
===============

Install and manage [RVM](https://rvm.io/) and Ruby installations in [Single-User](https://rvm.io/rvm/install#explained)
mode.

Install RVM
-----------

    single_user_rvm::install { 'username': }

More info in [install.pp](manifests/install.pp)

Install a couple of Rubies
--------------------------

    single_user_rvm::install_ruby { 'ruby-1.9.3-p392': user => 'username' }
    single_user_rvm::install_ruby { 'ruby-2.0.0-p247': user => 'username' }

More info in [install_ruby.pp](manifests/install_ruby.pp)

License
-------

Apache License, Version 2.0

Contact
-------

Eric Cohen <eirc.eirc@gmail.com>

Support
-------

Please log tickets and issues at our [Github issues page](https://github.com/eirc/puppet-single_user_rvm/issues)
