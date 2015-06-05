Joomlatools Vagrant box
=======================

![Screenshot](http://www.joomlatools.com/images/blog/2015/joomla-vagrant-13-dashboard.png)

This project automates the setup of a Joomla development environment.

It is capable of running a full featured LAMP stack with a single command so that you can start working on your Joomla projects quickly.

Installation
------------

1. Install [VirtualBox](http://www.virtualbox.org/)

1. Install [Vagrant](http://www.vagrantup.com/)

1. Run the following commands in a folder of your choice:

    ```
vagrant init joomlatools/box
vagrant up
    ```

    This will download the Vagrant box and get it running.

1. Add the following line into your ***hosts file*** (/etc/hosts on Linux and MacOS, for other operating systems see [here](http://en.wikipedia.org/wiki/Hosts_(file)#Location_in_the_file_system))

    ```
33.33.33.58 joomla.box webgrind.joomla.box phpmyadmin.joomla.box
    ```

1. The dashboard is now available at [joomla.box](http://joomla.box)

There will be two new folders created called `www` and `Projects`. These folders act as shared folders between your host computer and the box.

Getting started
---------------

1. Once you have installed the box as described above, SSH into the box:

      ```
vagrant ssh
```

1. Create your first Joomla website with this command:

    ```
joomla site:create mysite
    ```

1. Your new site is available at [joomla.box/mysite](http://joomla.box/mysite). You can login using the credentials  `admin` / `admin`.

1. You can now symlink and install your custom extensions into the site, manage PHP versions and much more. Head over to our [documentation pages](http://developer.joomlatools.com/tools/vagrant/introduction.html) to learn more about the box and its possibilities.


For hacking on the box
----------------------

If you want to make changes to the box's infrastructure, you can do so by building the box from scratch. Follow these steps to get started:

1. Clone this repository:

    ```
git clone https://github.com/joomlatools/joomla-vagrant.git
    ```

1. Install required Vagrant plugins

    ```
vagrant plugin install vagrant-puppet-install
vagrant plugin install vagrant-vbguest
    ```

1. Go to the repository folder and provision the box:

    ```
cd joomla-vagrant
vagrant up
    ```

1. You can now edit the Puppet configuration. To apply your changes, provision the box again:

    ```
vagrant provision
    ```

Reporting issues
----------------

We deliberately keep the Issues section on Github closed for now as we want to encourage people to submit code to add features or fix bugs by opening up Pull Requests instead of Issues.

Of course, it's not always easy to fix an obscure bug in someone else's code, but we still want to encourage everyone to make an effort. We do not have the intention to maintain a support forum here just yet!


Contributing
------------

Fork the project, create a feature branch from the `develop` branch, and send us a pull request.


Authors
-------

See the list of [contributors](https://github.com/joomlatools/joomla-vagrant/contributors).
