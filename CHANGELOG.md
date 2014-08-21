CHANGELOG
=========

This changelog references the relevant changes (bug and security fixes) done
in 1.x versions.

To get the diff for a specific change, go to https://github.com/joomlatools/joomla-vagrant/commit/xxx where xxx is the change hash.
To view the diff between two versions, go to https://github.com/joomlatools/joomla-vagrant/compare/v1.0.0...v1.0.1

* 1.2.2 (2014-08-21)
 * Added - Share the path mappings with guest box through BOX_SHARED_PATHS environment variable.
 * Added - Install PECL yaml by default.

* 1.2.1 (2014-07-04)
 * Added - Created a basic dashboard in the root path
 * Fixed - Disable APC dashboard authentication
 * Added - Set a JOOMLATOOLS_BOX environment variable in Apache
 * Fixed - Improved README, added login details + precompiled box instructions

* 1.2.0 (2014-03-17)
 * Added - [Joomla console package](https://github.com/joomlatools-console) is now available in the box.
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