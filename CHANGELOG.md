CHANGELOG
=========

This changelog references the relevant changes (bug and security fixes) done
in 1.x versions.

To get the diff for a specific change, go to https://github.com/joomlatools/joomlatools-vagrant/commit/xxx where xxx is the change hash.
To view the diff between two versions, go to https://github.com/joomlatools/joomlatools-vagrant/compare/v1.0.0...v1.0.1

* 1.5.1 (2018-06-19)
  * Added - Install php-ldap extension [#123](https://github.com/joomlatools/joomlatools-vagrant/issues/123)
  * Added - Install `tmate` to share terminal [#120](https://github.com/joomlatools/joomlatools-vagrant/issues/120)
  * Fixed - Prevent updater from running simultaneously [#121](https://github.com/joomlatools/joomlatools-vagrant/issues/121)
  * Fixed - Make sure auto-updater updates dependencies too [#126](https://github.com/joomlatools/joomlatools-vagrant/issues/126)
  * Fixed - Restart Nginx in box command [#118](https://github.com/joomlatools/joomlatools-vagrant/issues/118)
  * Fixed - Fix scrolling in site list [#113](https://github.com/joomlatools/joomlatools-vagrant/issues/113)
  * Improved - Update phing/phing to 3.x [#124](https://github.com/joomlatools/joomlatools-vagrant/issues/124)
  * Removed - `vagrant-triggers` for backup and restore [#125](https://github.com/joomlatools/joomlatools-vagrant/issues/125)

* 1.5.0 (2017-11-06)
  * Improved - Use PHP-FPM instead of mod_php [#28](https://github.com/joomlatools/joomlatools-vagrant/issues/28)
  * Improved - New joomla.box dashboard design [#13](https://github.com/joomlatools/joomlatools-vagrant/issues/13)
  * Improved - Initial refactoring of Puppet code to roles & profile workflow [#45](https://github.com/joomlatools/joomlatools-vagrant/issues/45)
  * Improved - Upgrade to Webgrind 1.5 [#74](https://github.com/joomlatools/joomlatools-vagrant/issues/74)
  * Improved - Move Varnish to port :8080 and improve VCL [#85](https://github.com/joomlatools/joomlatools-vagrant/issues/85)
  * Improved - Query site list from joomlatools/console [#86](https://github.com/joomlatools/joomlatools-vagrant/issues/86)
  * Fixed - Increase disk size [#71](https://github.com/joomlatools/joomlatools-vagrant/issues/71)
  * Fixed - Set the `nolock` mount option [#75](https://github.com/joomlatools/joomlatools-vagrant/pull/75)
  * Fixed - Install missing `zip` command [#82](https://github.com/joomlatools/joomlatools-vagrant/issues/82)
  * Fixed - Make sure Xdebug works for custom PHP 7.x versions [#90](https://github.com/joomlatools/joomlatools-vagrant/issues/90)
  * Added - Install default PHP from the [ondrej/php](https://launchpad.net/~ondrej/+archive/ubuntu/php) repository [#69](https://github.com/joomlatools/joomlatools-vagrant/issues/69)
  * Added - Add Toggle command to Box script [#84](https://github.com/joomlatools/joomlatools-vagrant/issues/84)
  * Added - Run Nginx on port 81 [#106](https://github.com/joomlatools/joomlatools-vagrant/issues/106)
  * Added - Add Terminal window to dashboard on larger screens [#108](https://github.com/joomlatools/joomlatools-vagrant/issues/108)
  * Removed - Remove Z-Ray and HHVM [#96](https://github.com/joomlatools/joomlatools-vagrant/issues/96)  
  
* 1.4.4 (2016-04-07)
  * Added - Installed the Composer plugin [hirak/prestissimo](https://github.com/hirak/prestissimo) [#14](https://github.com/joomlatools/joomlatools-vagrant/issues/14)
  * Fixed - Configure PHP's OpenSSL to find the CA bundles [#22](https://github.com/joomlatools/joomlatools-vagrant/issues/22) 
  * Fixed - Add `joomla.box` to hosts file [#16](https://github.com/joomlatools/joomlatools-vagrant/issues/16)
  * Fixed - Fix extra slash in administrator urls on dashboard [#19](https://github.com/joomlatools/joomlatools-vagrant/pull/19)
  * Improved - Upgraded Z-Ray to latest versions [#21](https://github.com/joomlatools/joomlatools-vagrant/issues/21)

* 1.4.3 (2015-12-01)
  * Changed - Renamed `joomlatools/joomla-console` to `joomlatools/console`

* 1.4.2 (2015-11-25)
  * Added - `JOOMLATOOLS_BOX` version environment variable
  * Added - Install [joomlatools/joomla-console-joomlatools](https://github.com/joomlatools/joomlatools-console-joomlatools) plugin by default
  * Fixed - Always pass requests to /ZendServer end-point
  * Fixed - Symlink `/opt/zray` to active Z-Ray installation to fix plugin gallery
  * Fixed - Ensure that hostname is always set to `joomlatools` using Puppet configuration
  * Improved - Use a single zray.ini file and zray.conf virtual host
  * Improved - Disable Z-Ray on tools (dashboard, phpmyadmin, webgrind, pimpmylog)
  * Improved - Decrease box size

* 1.4.1 (2015-11-11)
  * Added - Install Z-Ray [Joomla](https://www.yireo.com/software/joomla-extensions/zray) and [Composer](https://github.com/zend-server-extensions/Z-Ray-Composer) plugins
  * Improved - Automatically enable Xdebug if it's disabled when starting the profiler
  * Fixed - Make sure dashboard can retrieve Joomla 3.5.0 version out of `JVersion` class
  * Fixed - Automated installation of `vagrant-triggers` plugin failed on Windows hosts

* 1.4.0 (2015-11-05)
  * Added - `box php:engine hhvm` command to switch to HHVM
  * Added - `box xdebug:profiler start|stop` command to turn on Xdebug profiling
  * Added - [Zend Z-Ray](http://www.zend.com/en/products/z-ray/z-ray-preview) preview
  * Added - [httpie](https://github.com/jkbrzt/httpie) CLI HTTP Client
  * Added - [Cloudcommander](http://cloudcmd.io/) web-based file browser
  * Added - System will automatically look for  [joomlatools/joomla-console](http://developer.joomlatools.com/tools/console.html) updates
  * Added - Installed Varnish cache in front of Apache
  * Added - Automatically backup and restore virtual hosts and databases when upgrading the box
  * Fixed - Upgraded Webgrind to automatically find cachegrind files
  * Fixed - Consolidate the PHP ini files into a single custom.ini file
  * Improved - Automatically change directory to /var/www when logging in via `vagrant ssh` or web terminal
  * Improved - Xdebug is now disabled by default
  * Improved - Added /terminal, /mailcatcher and /filebrowser aliases
  * Improved - Added bash autocompletion to the `box` command

* 1.3.1 (2015-09-03)
  * Added - Support for PHP7
  * Added - Support for [joomla-platform](https://github.com/joomlatools/joomlatools-platform) installations
  * Added - Installed git-ftp
  * Added - `box server:restart` command
  * Improved - Use the async option when mounting NFS on Linux
  * Improved - Link to both site and administrator in dashboard listing
  * Fixed - Allow value _0_ to be written to PHP ini using `box php:ini`
  * Fixed - Use bison 2.4 when building PHP 5.4.19+
  * Fixed - Point to global apc-dashboard.php file in `/apc` alias

* 1.3.0 (2015-06-01)
  * Improved - Upgraded default PHP to 5.5
  * Improved - Upgraded OS and stack: Ubuntu 14.04, Apache 2.4, Puppet 3.4, Ruby 2.2
  * Improved - Add "getting started" instructions to MOTD
  * Improved - Installed RVM for the `vagrant` user
  * Improved - Install mailcatcher for the vagrant user instead of globally
  * Improved - Consolidated all server-related commands into a single `box` command. (apc, xdebug, phpmanager, ..)
  * Added - Created the box dashboard available at joomla.box
  * Added - Installed Wetty (web terminal)
  * Added - Installed PimpMyLog for access to server logs via browser
  * Added - Installed PhpMetrics
  * Added - Create a Packer template
  * Added - Enable SSL by default to joomla.box and all newly created hosts
  * Added - Capistrano gem
  * Added - Bundler gem
  * Fixed - Fix gsub error when adding incorrect shared folders
  * Fixed - Broken dependencies for Mailcatcher
  * Fixed - Fix phpmyadmin puppet manifest on Windows (#8)
  * Fixed - Suppress STDERR output when restarting Apache
  * Fixed - Compile and configure Opcache and APCu by default when building PHP versions greater than 5.5
  * Fixed - Use Xdebug v2.2.7 for PHP versions older than 5.4.0
  * Fixed - Do not delete php binaries on `phpmanager restore` if using system default
  * Removed - Removed XHProf

* 1.2.2 (2014-08-21)
  * Added - Share the path mappings with guest box through BOX_SHARED_PATHS environment variable.
  * Added - Install PECL yaml by default.
  * Fixed - Fixed broken mysql-5.1.73 download link.
  * Fixed - Running the box straight from `joomlatools/box` fails to find the _config.custom.yaml_ file.

* 1.2.1 (2014-07-04)
  * Added - Created a basic dashboard in the root path
  * Added - Set a JOOMLATOOLS_BOX environment variable in Apache
  * Fixed - Disable APC dashboard authentication
  * Fixed - Improved README, added login details + precompiled box instructions

* 1.2.0 (2014-03-17)
  * Added - [Joomla console package](https://github.com/joomlatools/joomlatools-console) is now available in the box.
  * Added - phpmanager command to allow installation and management of multiple PHP versions.
  * Added - xdebug command to easily enable/disable PHP Xdebug extension.
  * Added - apc command to easily enable/disable PHP APC extension as well as clear the cache.
  * Added - Sass is now installed automatically.
  * Added - Default virtual host joomla.dev
  * Added - joomla.dev/apc and joomla.dev/phpinfo aliases

* 1.1.0 (2014-01-12)
  * Added - Joomla 3.2 site template to be used with joomla command
  * Added - New command line script: remove_dotunderscore (Removes files starting with ._ in the current directory. See: http://kadin.sdf-us.org/weblog/technology/software/deleting-dot-underscore-files.html)

* 1.0.0 (2013-08-08)
  * Added - Initial release
