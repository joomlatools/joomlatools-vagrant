Joomlatools Vagrant box
=======================

This project automates the setup of a Joomla development environment. 

It is capable of running a full featured LAMP stack with a single command so that you can start working on your Joomla projects quickly.

The setup includes:
-------------------
* LAMP (Ubuntu 12.10, Apache, MySQL 5.5, PHP 5.4)
* Phpmyadmin
* Composer
* Xdebug
* Webgrind
* Mailcatcher
* Less and SASS compilers
* UglifyJS

Installation
------------

Install [VirtualBox](http://www.virtualbox.org/)

Install [Vagrant](http://www.vagrantup.com/)

Run the following commands in a folder of your choice:

    $ vagrant init joomlatools/box
    $ vagrant up
    
This will download the Vagrant box and get it running. 

Note that this requires a 700 MB download for the first run and Vagrant version 1.5 or later. If you want to perform an offline installation or on an older Vagrant version, [download the box here](https://vagrantcloud.com/joomlatools/box/version/3/provider/virtualbox.box) and run the following commands instead:

    $ vagrant init joomlatools/box /path/to/download/joomlatools-box-1.2.box
    $ vagrant up
        
Add the following line into your ***hosts file*** (/etc/hosts on Linux and MacOS, for other operating systems see [here](http://en.wikipedia.org/wiki/Hosts_(file)#Location_in_the_file_system))

    33.33.33.58 joomla.dev webgrind.joomla.dev phpmyadmin.joomla.dev

And you are done. There will be two new folders created called www and Projects.

For hacking on the box
----------------------

Clone this repository

    $ git clone https://github.com/joomlatools/joomla-vagrant.git

Go to the repository folder and provision the box

    $ cd joomla-vagrant
    $ vagrant up

Apache
------

Apache serves files from the www/ folder using the IP:

    http://33.33.33.58/

If you have setup your hosts file correctly as shown above, you can now also access the default www/ folder at:

    http://joomla.dev/

It is advised to use virtual hosts for development. See below for our virtual host manager.

SSH
---
You can reach the box by using the command:

    $ vagrant ssh

Joomla Site Manager
-------------------

The Vagrant box has our [Joomla Console](https://github.com/joomlatools/joomla-console) script pre-installed.
To create a site with the latest Joomla version, run:

    joomla site:create testsite

The newly installed site will be available in the /testsite subfolder at http://joomla.dev/testsite after that. The files are located at /var/www/testsite.
You can login into your fresh Joomla installation using these credentials: `admin` / `admin`.

For more information, please refer to the [Joomla Console](https://github.com/joomlatools/joomla-console) repository.

*Note*: The script also creates a new virtual host when creating a new site. If you add the following line into your /etc/hosts file on your host machine:

    33.33.33.58 testsite.dev

you can access it directly at http://testsite.dev.

Symlink your code into a Joomla installation
--------------------------------------------
Let's say you are working on your own Joomla component called _Awesome_ and want to continue working on it using the Vagrant box. You can use the _Projects_ folder in the repository root for your projects.

But if you would like to use a custom folder we should start by making the source code available to the Vagrant box. Let's assume the source code is located at _/Users/myname/Projects/awesome_ :

Copy the ```config.custom.yaml-dist``` file to ```config.custom.yaml``` and edit with your favorite text editor. Make it look like this:

    synced_folders:
      /home/vagrant/Projects: /Users/myname/Projects

Save this file and restart the Vagrant box. (```vagrant reload```)

The "Projects" folder from your host machine will now be available inside the Vagrant box through _/home/vagrant/Projects_.

Next step is to create the new site you'll be working on. SSH into the box (```vagrant ssh```) and execute the following command: 

    joomla site:create testsite --joomla=3.2 --symlink=awesome

Or to symlink your code into an existing site:

    joomla extension:symlink testsite awesome

Run discover install to make your component available to Joomla and you are good to go!

For more information on the symlinker, refer to the [Joomla Console README](https://github.com/joomlatools/joomla-console) or run:

      joomla extension:symlink  --help


MySQL
-----

After you modify /etc/hosts as shown above you can use phpMyAdmin at

    http://phpmyadmin.joomla.dev

You can also connect using any MySQL client with these details:

    Host: 33.33.33.58
    User: root
    Password: root


Managing multiple PHP Versions
------------------------------

We have included a script that can build and install any PHP version from 5.2.0 and up automatically. This is ideal to try out your code on new PHP releases or to fix bugs that have been reported on older PHP installations.

To get a list of available PHP versions, SSH into the box and run:

    phpmanager versions
    
To install one of the available versions, for example 5.2.16, execute:

    phpmanager use 5.2.16
    
The script will check if this version has been installed and if not, will attempt to build it. Please note that building PHP might take a while. Depending on your system, this could take between 5 and 45 minutes.

If you want to test your code against the latest and greatest of PHP, you can call ```phpmanager use master```. Each time you build the master branch the script will pull in the latest changes from the PHP Git repository.

To restore the original PHP installation again, run:

    phpmanager restore
    
For more options, run ```phpmanager --help```. To see this script in action, refer to this [screencast](http://quick.as/5aw1ulxx).

APC and XDebug
--------------

You can easily turn XDebug and APC on or off after SSHing into the Vagrant box:

    xdebug enable|disable
    apc enable|disable
    
To clear the APC cache, run:

    apc clear
    
You can always access the APC dashboard through the /apc folder. (```http://joomla.dev/apc```)

Webgrind
--------

After you modify /etc/hosts as shown above go to

    http://webgrind.joomla.dev

SFTP
----

Use following details to connect:

    Host: 127.0.0.1
    Port: 2222
    User: vagrant
    Password: vagrant

