# Class: phpmyadmin
#
# This installs phpMyAdmin on your machine.
# Needed passwords have to be provided by custom facts. In this way
# no password has to be added to resource calls.
# Look at the custom facter provided by this module
# to get to know how the needed facts have to be stored on the machine.
#
# Requires:
#   non-empty password for root
#   fact: pma_mysql_root_password
#   fact: pma_controluser_password
#
# Example Usage:
#
#   class { 'phpmyadmin':
#   }
#
# @TODO configuration,configuration,configuration ...
#
class phpmyadmin (
) {

  package { 'phpmyadmin':
    ensure => present,
  }
  ->
  file { '/etc/phpmyadmin/config.inc.php':
    ensure   => file,
    replace  => true,
    owner    => root,
    group    => root,
    mode     => '0644',
    content  => template('phpmyadmin/config.inc.php'),
  }
  ->
  file { '/usr/share/phpmyadmin/config.inc.php':
    ensure => link,
    owner  => root,
    group  => root,
    mode   => '0644',
    target => '/etc/phpmyadmin/config.inc.php',
  }
  ->
  file { '/etc/phpmyadmin/config-db.php':
    ensure   => file,
    replace  => true,
    owner    => root,
    group    => www-data,
    mode     => '0640',
    content  => template('phpmyadmin/config.db.php'),
  }
  ->
  # phpMyAdmin will display a warning if its control user 
  # is equal to the mysql root user and so
  # we create the default phpmyadmin user here.
  # On some machines the phpmyadmin user might be already installed.
  # We have to drop and re-add this user because of new privileges and password.
  exec{ 'creating-phpmyadmin-controluser':
    command => "echo \"CREATE USER 'phpmyadmin'@'localhost'\
      IDENTIFIED BY '${::pma_controluser_password}';\
      GRANT ALL ON *.* TO 'phpmyadmin'@'localhost';FLUSH PRIVILEGES;\"\
      | mysql -u root -p'${::pma_mysql_root_password}'",
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    unless  => "mysql -u root -p'${::pma_mysql_root_password}'\
      -e 'select * from mysql.user WHERE User=\"phpmyadmin\"' \
      | grep 'phpmyadmin'"
  }
}
