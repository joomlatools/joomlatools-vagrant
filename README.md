Joomlatools Vagrant box
=======================

The setup includes:
-------------------
* Ubuntu 12.10 (Precise) 64 bit
* Apache
* MySQL
* PHP 5.4 
* Composer
* Phpmyadmin
* Xdebug
* Webgrind
* Mailcatcher
* Less compiler
* UglifyJS

Installation
------------

Install [VirtualBox](http://www.virtualbox.org/)

Install [Vagrant](http://downloads.vagrantup.com/)

Clone this repository

    $ git clone https://github.com/joomlatools/joomla-vagrant.git

Go to the repository folder and create the box

    $ cd joomla-vagrant
    $ vagrant up

Add the following line into your ***hosts file*** (in linux /etc/hosts, for other operating systems see: http://en.wikipedia.org/wiki/Hosts_(file)#Location_in_the_file_system)

    33.33.33.58 webgrind phpmyadmin

There will be two folders created in that folder called www and projects.

Apache
------

Apache serves files from the www/ folder using the IP:

    http://33.33.33.58/

It is advised to use virtual hosts for development. See below for our virtual host manager.

SSH
---
You can reach the box by using the command:

	$ vagrant ssh

Joomla Site Manager
-------------------

This is a script developed by Joomlatools to ease the management of Joomla sites from command line.

To create an empty site with it, SSH into the box and then run:

    joomla create testsite

Add the following line into your /etc/hosts file on your host machine:

    33.33.33.58 testsite.dev

Now you can reach the ```www/testsite``` folder from the domain testsite.dev
    
You can have the script pre-install Joomla for you. Just run ```joomla --version=3 create testsite```to setup the latest Joomla 3 version. You can ask the script to install sample data by adding the ```--sample``` flag. You can install any branch from the Git repository or any version from 2.5.0 and up using this command. See [this demo](http://quick.as/kvjjsg6g) to see how the script works.

For more information and available options, try running:

    joomla --help


Symlink your code into a Joomla installation
--------------------------------------------
Let's say you are working on your custom Joomla 3.2 component called _MyComponent_ and want to continue working on it using the Vagrant box.

If your source code is located at _/Users/myname/Projects/mycomponent_, we should start by making this directory available to the Vagrant box.

Copy the ```config.custom.yaml-dist``` file to ```config.custom.yaml``` and edit with your favorite text editor. Make it look like this:

	synced_folders:
	  /var/www: ./www
	  /home/vagrant/Projects: /Users/myname/Projects

Save this file and start the Vagrant box. (```vagrant up```)

The "Projects" folder from your host machine will now be available inside the Vagrant box through _/home/vagrant/Projects_.

Next step is to create the new site you'll be working on. SSH into the box (```vagrant ssh```) and execute the following command: 

	joomla --version=3.2 --symlink=mycomponent create testsite

The script will create a new Joomla 3 installation for you and symlink all the folders from the _mycomponent_ folder into it. Now add _testsite.dev_ to your /etc/hosts as described in the previous paragraph, so you can access the new site via _http://testsite.dev_ 

Your component files are now symlinked into the _mycomponent.dev_ site. Setup the necessary database tables and you're ready to go!

You don't have to create a new site each time you want to symlink files into one of your Vagrant sites. You can use the ```symlinker``` command directly.
SSH into the Vagrant box and run:

	symlinker /home/vagrant/Projects/mydirectory /var/www/mycomponent/ 
	
This will link every file and folder inside _/home/vagrant/Projects/mydirectory_ into the _/var/www/mycomponent_ directory.
For more info on the symlinker, run: 

	symlinker --help

MySQL
-----

After you modify /etc/hosts as shown above you can use phpMyAdmin at

    http://phpmyadmin

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

Webgrind
--------

After you modify /etc/hosts as shown above go to

    http://webgrind

SFTP
----

Use following details to connect:

    Host: 127.0.0.1
    Port: 2222
    User: vagrant
    Password: vagrant


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/joomlatools/joomla-vagrant/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

