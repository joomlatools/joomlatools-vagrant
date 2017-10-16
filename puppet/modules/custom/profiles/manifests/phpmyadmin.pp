class profiles::phpmyadmin {

  require ::profiles::apache
  require ::profiles::php
  require ::profiles::mysql

  $mysql_root_password = hiera('profiles::mysql::root_password', 'root')

  file { '/usr/share/phpmyadmin':
    ensure => directory,
    owner  => vagrant,
    group  => vagrant
  }

  exec { 'install-phpmyadmin':
    command => 'composer create-project phpmyadmin/phpmyadmin /usr/share/phpmyadmin "^4.7.0" -q --repository-url=https://www.phpmyadmin.net/packages.json --no-dev --no-interaction',
    unless  => 'test -f /usr/share/phpmyadmin/composer.json',
    path    => ['/usr/local/bin', '/usr/bin'],
    user    => vagrant,
    environment => 'COMPOSER_HOME=/home/vagrant/.composer',
    require => [File['/usr/share/phpmyadmin'], Anchor['php::end']]
  }

  file { '/usr/share/phpmyadmin/config.inc.php':
    ensure   => file,
    replace  => true,
    owner    => vagrant,
    group    => vagrant,
    mode     => '0644',
    content  => template('profiles/phpmyadmin/config.inc.php'),
    require  => Exec['install-phpmyadmin']
  }

  # phpMyAdmin will display a warning if its control user
  # is equal to the mysql root user and so
  # we create the default phpmyadmin user here.
  # On some machines the phpmyadmin user might be already installed.
  # We have to drop and re-add this user because of new privileges and password.
  exec{ 'creating-phpmyadmin-controluser':
    command => "echo \"CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY 'phpmyadmin';\
      GRANT ALL ON *.* TO 'phpmyadmin'@'localhost';FLUSH PRIVILEGES;\"\
      | mysql -u root -p'${mysql_root_password}'",
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    unless  => "mysql -u root -p'${mysql_root_password}' -e 'select * from mysql.user WHERE User=\"phpmyadmin\"' | grep 'phpmyadmin'",
    require => Service['mysql']
  }

  apache::vhost { 'phpmyadmin':
    server_name   => 'phpmyadmin',
    serveraliases => 'phpmyadmin.joomla.box',
    docroot       => '/usr/share/phpmyadmin',
    port          => 8080,
    priority      => '10'
  }

}