group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ] }
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

class apache::certificate {
  class { 'openssl': }

  file { ['/etc/apache2',  '/etc/apache2/ssl']:
    ensure => 'directory',
  }

  openssl::certificate::x509 { 'server':
    country      => 'BE',
    organization => 'Joomlatools',
    commonname   => 'localhost.ssl',
    email        => 'info@joomlatools.com',
    days         => 3650,
    base_dir     => '/etc/apache2/ssl',
  }
}

class { 'apache::certificate':}

class { 'apache':
    require => Class['apache::certificate'],
}

apache::dotconf { 'custom':
  content => template("apache/custom.conf.erb"),
}

apache::module { 'rewrite': }
apache::module { 'ssl': }

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
  require => [Php::Pear::Config['download_dir'], Package['libyaml-dev']]
}

puphpet::ini { 'yaml':
  value   => [
    'extension=yaml.so'
  ],
  ini     => '/etc/php5/conf.d/zzz_yaml.ini',
  notify  => Service['apache'],
  require => [Class['php'], Php::Pecl::Module['yaml']]
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

puphpet::ini { 'custom':
  value   => [
    'sendmail_path = /home/vagrant/.rvm/gems/ruby-2.0.0-p247/bin/catchmail -fnoreply@example.com',
    'display_errors = On',
    'error_reporting = -1',
    'display_startup_errors = On',
    'upload_max_filesize = "256M"',
    'post_max_size = "256M"',
    'memory_limit = "256M"',
    'date.timezone = "UTC"'
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
    user        => vagrant,
    command     => 'bash -c "source ~/.rvm/scripts/rvm; rvm --default use 2.0.0-p247"',
    environment => ['HOME=/home/vagrant'],
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vagrant/.rvm/bin/',
    require     => Single_user_rvm::Install_ruby['ruby-2.0.0-p247']
}

class {'mailcatcher':
    require => Exec['set-default-ruby-for-vagrant']
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

apache::vhost { 'joomla.box':
  server_admin  => 'webmaster@localhost',
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
  require => Apache::Vhost['joomla.box']
}

class { 'scripts': }

class { 'phpmanager': }

exec {'install-capistrano-gem':
    user    => vagrant,
    command => 'bash -c "source ~/.rvm/scripts/rvm; gem install capistrano"',
    environment => ['HOME=/home/vagrant'],
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vagrant/.rvm/bin/',
    require => Exec['set-default-ruby-for-vagrant']
}

exec {'install-bundler-gem':
    user    => vagrant,
    command => 'bash -c "source ~/.rvm/scripts/rvm; gem install bundler"',
    environment => ['HOME=/home/vagrant'],
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vagrant/.rvm/bin/',
    require => Exec['set-default-ruby-for-vagrant']
}

class { 'box':
    require => [Class['composer'], Class['phpmanager']]
}

class {'wetty': }

file { '/etc/update-motd.d/999-joomlatools':
  ensure => 'present',
  mode   => 'ug+rwx,o+rx',
  source => 'puppet:///modules/motd/joomlatools',
}

file { ['/etc/update-motd.d/10-help-text', '/etc/update-motd.d/91-release-upgrade']:
    ensure => absent
}

class { 'pimpmylog': }
class { 'phpmetrics':
    require => Class['composer']
}