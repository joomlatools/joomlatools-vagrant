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

Installation:
-----------
Install [VirtualBox](http://www.virtualbox.org/)

Install [Vagrant](http://downloads.vagrantup.com/)

Clone this repository

Go to the repository folder and launch the box

    $ cd [repo]
    $ vagrant up

Add the following line into /etc/hosts
    
    192.168.51.10 webgrind xhprof phpmyadmin

Apache serves files from the www/ folder in the repository root

You can reach the box by using the command:

	$ vagrant ssh
