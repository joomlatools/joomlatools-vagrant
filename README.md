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

Add the following line into /etc/hosts

    33.33.33.58 webgrind phpmyadmin

There will be two folders created in that folder called www and projects.

Apache
------

Apache serves files from the www/ folder using the IP:

    http://33.33.33.58/

It is advised to use virtual hosts for development. See the following link for a tutorial:

    https://www.digitalocean.com/community/articles/how-to-set-up-apache-virtual-hosts-on-ubuntu-12-04-lts

MySQL
-----

After you modify /etc/hosts as shown above you can use phpMyAdmin at

    http://phpmyadmin

You can also connect using any MySQL client with these details:

    Host: 33.33.33.58
    User: root
    Password: root

Webgrind
--------

After you modify /etc/hosts as shown above go to

    http://webgrind


SSH
---
You can reach the box by using the command:

	$ vagrant ssh

SFTP
----

Use following details to connect:

    Host: 127.0.0.1
    Port: 2222
    User: vagrant
    Password: vagrant
