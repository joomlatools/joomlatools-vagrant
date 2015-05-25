group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File { owner => 0, group => 0, mode => 0644 }

class {'apt':
  always_apt_update => true,
}

Class['::apt::update'] -> Package <|
    title != 'python-software-properties'
and title != 'software-properties-common'
|>

    apt::key { '4F4EA0AAE5267A6C': }

apt::ppa { 'ppa:ondrej/php5-oldstable':
  require => Apt::Key['4F4EA0AAE5267A6C']
}

file { '/home/vagrant/.bash_aliases':
  ensure => 'present',
  source => 'puppet:///modules/puphpet/dot/.bash_aliases',
}

package { [
    'build-essential',
    'vim',
    'curl',
    'git-core',
    'unzip'
  ]:
  ensure  => 'installed',
}

package { ['sass', 'compass']:
  ensure   => 'installed',
  provider => 'gem',
}

class { 'apache': }

apache::dotconf { 'custom':
  content => 'EnableSendfile Off',
}

apache::module { 'rewrite': }

class { 'php':
  service       => 'apache',
  module_prefix => '',
  require       => Package['apache'],
}

php::module { 'php5-mysql': }
php::module { 'php5-cli': }
php::module { 'php5-curl': }
php::module { 'php5-gd': }
php::module { 'php5-imagick': }
php::module { 'php5-intl': }
php::module { 'php5-mcrypt': }
php::module { 'php5-sqlite': }
php::module { 'php5-xcache': }
php::module { 'php-apc': }

class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}

php::pear::config {
  download_dir: value => "/tmp/pear/download",
  require => Class['php::pear']
}

php::pear::module { 'Console_CommandLine':
  use_package => false
}

php::pear::module { 'Phing':
  use_package => false,
  repository  => 'pear.phing.info'
}

package { 'libyaml-dev':
  ensure => present,
}

php::pecl::module { 'yaml':
  use_package => no,
  ensure => present,
  require => [php::pear::config['download_dir'], Package['libyaml-dev']]
}

puphpet::ini { 'yaml':
  value   => [
    'extension=yaml.so'
  ],
  ini     => '/etc/php5/conf.d/zzz_yaml.ini',
  notify  => Service['apache'],
  require => [Class['php'], php::pecl::module['yaml']]
}

class { 'xdebug':
  service => 'apache',
}

class { 'composer':
  require => Package['php5', 'curl'],
}

puphpet::ini { 'xdebug':
  value   => [
    'xdebug.remote_autostart = 0',
    ';Use remote_connect_back = 0 if accessing a shared box',
    'xdebug.remote_connect_back = 1',
    'xdebug.remote_enable = 1',
    'xdebug.remote_handler = "dbgp"',
    'xdebug.remote_port = 9000',
    'xdebug.remote_host = "33.33.33.1"',
    'xdebug.show_local_vars = 1',
    'xdebug.profiler_enable = 0',
    'xdebug.profiler_enable_trigger = 1',
    'xdebug.max_nesting_level = 1000',
    'xdebug.profiler_output_dir = /var/www/logs/xdebug/'
  ],
  ini     => '/etc/php5/conf.d/zzz_xdebug.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

puphpet::ini { 'php':
  value   => [
    'date.timezone = "UTC"'
  ],
  ini     => '/etc/php5/conf.d/zzz_php.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

puphpet::ini { 'custom':
  value   => [
    'sendmail_path = /opt/vagrant_ruby/bin/catchmail -fnoreply@example.com',
    'display_errors = On',
    'error_reporting = -1',
    'display_startup_errors = On',
    'upload_max_filesize = "256M"',
    'post_max_size = "256M"',
    'memory_limit = "64M"'
  ],
  ini     => '/etc/php5/conf.d/zzz_custom.ini',
  notify  => Service['apache'],
  require => Class['php'],
}


class { 'mysql::server':
  config_hash   => {
    'root_password' => 'root',
    'bind_address' => false
  }
}

exec { 'grant-all-to-root':
  command     => "mysql --user='root' --password='root' --execute=\"GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;\"",
  require => Class['phpmyadmin']
}

class { 'phpmyadmin':
  require => [Class['mysql::server'], Class['mysql::config'], Class['php']],
}

apache::vhost { 'phpmyadmin':
  server_name   => 'phpmyadmin',
  serveraliases => 'phpmyadmin.joomla.box',
  docroot       => '/usr/share/phpmyadmin',
  port          => 80,
  priority      => '10',
  require       => Class['phpmyadmin'],
}

user { 'vagrant': }

single_user_rvm::install { 'vagrant': }
single_user_rvm::install_ruby { 'ruby-2.0.0-p247':
    user => vagrant
}

exec {'set-default-ruby-for-vagrant':
 user    => vagrant,
 command => 'bash -c "source ~/.rvm/scripts/rvm; rvm --default use 2.0.0-p247"',
 environment => ['HOME=/home/vagrant'],
 path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vagrant/.rvm/bin/',
 require => Single_user_rvm::Install_ruby['ruby-2.0.0-p247']
}

class { 'less': }

class { 'uglifyjs': }

class { 'webgrind': 
  require => Package['unzip'],
}

apache::vhost { 'webgrind':
  server_name   => 'webgrind',
  serveraliases => 'webgrind.joomla.box',
  docroot       => '/usr/share/webgrind',
  port          => 80,
  priority      => '10',
  require       => Class['webgrind'],
}

apache::vhost { 'default':
  server_admin  => 'webmaster@localhost',
  serveraliases => 'joomla.box',
  port          => 80,
  priority      => '',
  docroot       => '/var/www',
  directory     => '/var/www',
  directory_allow_override   => 'All',
  directory_options => 'Indexes FollowSymLinks MultiViews',
  template     => 'apache/virtualhost/joomlatools.vhost.conf.erb',
}

exec { 'set-env-for-debugging':
  command => "echo \"\nSetEnv JOOMLATOOLS_BOX 1\" >> /etc/apache2/apache2.conf",
  unless  => "grep JOOMLATOOLS_BOX /etc/apache2/apache2.conf",
  notify  => Service['apache'],
  require => Apache::Vhost['default']
}

class { 'scripts': }

class { 'phpmanager': }

