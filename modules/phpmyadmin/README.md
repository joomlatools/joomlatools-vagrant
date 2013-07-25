# puppet-phpmyadmin

Puppet module for installing phpMyAdmin. It is independant from installed webserver
and you do have to configure the needed vhost for accessing phpMyAdmin on your own.

## Credentials
During installation a phpmyadmin controller user is created with equal name.
The password for this user and the one for the mysql root user has to be provided
within facts. For security reasons it is not possible to assign those
credentials directly to the phpmyadmin class.

Please have a look at the custom facter in `lib/facter/phpmyadmin_facts.rb` for more information.

## Configuration
No further configuration supported currently but more to come!

## Author
* Frank Stelzer <frank.stelzer@sensiolabs.de>

powered by [SensioLabs Deutschland GmbH](http://www.sensiolabs.de)