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

This is a script developed by [Joomlatools](http://joomlatools.com) to ease the management of Joomla sites.

To create a site with the latest Joomla version, run:

    joomla site:create testsite

Add the following line into your /etc/hosts file on your host machine:

    33.33.33.58 testsite.dev

The newly installed site will be available at /var/www/testsite and testsite.dev after that.

You can choose the Joomla version or the sample data to be installed:

    joomla site:create testsite --joomla=2.5 --sample-data=blog

You can install any branch from the Git repository or any version from 2.5.0 and up using this command. See [this demo](http://quick.as/kvjjsg6g) to see how the script works.

For more information and available options, see [Joomlatools console repository](https://github.com/joomlatools/joomla-console) or try running:

    joomla --list


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

    joomla site:symlink testsite awesome

This will symlink all the folders from the _awesome_ folder into _testsite.dev_.
Please note that your source code should resemble the Joomla folder structure for symlinking to work well. For example your administrator section should reside in /Users/myname/Projects/awesome/administrator/components/com_awesome.

Now add _testsite.dev_ to your /etc/hosts as described in the previous paragraph, so you can access the new site via _http://testsite.dev_

Run discover install to make your component available to Joomla and you are good to go!

For more information on the symlinker, run:

	  joomla site:symlink  --help


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

