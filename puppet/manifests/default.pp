group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ], timeout => 900 }
File { owner => 0, group => 0, mode => 0644 }

user { 'vagrant': }

class {'apt':
  always_apt_update => true,
}

Class['::apt::update'] -> Package <|
  title != 'python-software-properties'
  and title != 'software-properties-common'
|>

apt::key { '4F4EA0AAE5267A6C': }

apt::ppa { 'ppa:ondrej/php5-5.6':
  require => Apt::Key['4F4EA0AAE5267A6C']
}

apt::ppa { 'ppa:resmo/git-ftp': }

include '::gnupg'
gnupg_key { 'gpg-rvm-signature':
  ensure     => present,
  key_id     => 'D39DC0E3',
  user       => 'vagrant',
  key_server => 'hkp://keys.gnupg.net',
  key_type   => public,
}

file { '/home/vagrant/.bash_aliases':
  ensure => 'present',
  owner  => vagrant,
  group  => vagrant,
  source => 'puppet:///modules/puphpet/dot/.bash_aliases',
}

package { [
  'build-essential',
  'vim',
  'curl',
  'git-core',
  'unzip'
]:
  ensure  => 'installed'
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

exec { 'apache-set-servername':
  command => "echo \"ServerName joomlatools\" > /etc/apache2/conf-available/fqdn.conf; a2enconf fqdn",
  path    => ['/usr/bin' , '/bin', '/usr/sbin/'],
  creates => '/etc/apache2/conf-available/fqdn',
  require => Class['apache']
}

apache::dotconf { 'custom':
  content => template("apache/custom.conf.erb"),
}

apache::module { 'rewrite': }
apache::module { 'ssl': }
apache::module { 'proxy_fcgi': }
apache::module { 'headers': }

class { 'php':
  service       => 'apache',
  version       => 'latest',
  module_prefix => '',
  require       => Package['apache'],
}

$apache_hhvm_proxy = "
<FilesMatch \\.php$>
  SetHandler \"proxy:fcgi://127.0.0.1:9000\"
</FilesMatch>"

file { '/etc/apache2/conf-available/hhvm.conf':
  ensure  => file,
  content => $apache_hhvm_proxy,
  require => Class['apache']
}

php::module { 'php5-mysql': }
php::module { 'php5-cli': }
php::module { 'php5-curl': }
php::module { 'php5-gd': }
php::module { 'php5-imagick': }
php::module { 'php5-intl': }
php::module { 'php5-mcrypt': }
php::module { 'php5-sqlite': }
php::module { 'php5-apcu': }

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
  ini     => '/etc/php5/mods-available/yaml.ini',
  notify  => Service['apache'],
  require => [Class['php'], Php::Pecl::Module['yaml']]
}

file { ['/etc/php5/apache2/conf.d/20-yaml.ini', '/etc/php5/cli/conf.d/20-yaml.ini']:
  ensure => link,
  target => '/etc/php5/mods-available/yaml.ini',
  require => Puphpet::Ini['yaml']
}

php::pecl::module { 'oauth':
  use_package => no,
  ensure      => present,
  require     => Php::Pear::Config['download_dir']
}

puphpet::ini { 'oauth':
  value   => [
    'extension=oauth.so'
  ],
  ini     => '/etc/php5/mods-available/oauth.ini',
  notify  => Service['apache'],
  require => [Class['php'], Php::Pecl::Module['oauth']]
}

file { ['/etc/php5/apache2/conf.d/20-oauth.ini', '/etc/php5/cli/conf.d/20-oauth.ini']:
  ensure => link,
  target => '/etc/php5/mods-available/oauth.ini',
  require => Puphpet::Ini['oauth']
}

class { 'xdebug':
  service => 'apache',
}

class { 'composer':
  require => Package['php5', 'curl'],
}

exec { "composer-plugin-changelogs":
  command => "composer global require pyrech/composer-changelogs",
  path    => ['/usr/bin' , '/bin'],
  creates => '/home/vagrant/.composer/vendor/pyrech/composer-changelogs',
  user    => vagrant,
  environment => 'COMPOSER_HOME=/home/vagrant/.composer',
  require => Class['Composer']
}

puphpet::ini { 'custom':
  value   => [
    'sendmail_path = /home/vagrant/.rvm/gems/ruby-2.2.1/bin/catchmail -fnoreply@example.com',
    'display_errors = On',
    'error_reporting = E_ALL & ~E_NOTICE',
    'display_startup_errors = On',
    'upload_max_filesize = "256M"',
    'post_max_size = "256M"',
    'memory_limit = "256M"',
    'date.timezone = "UTC"',
    'xdebug.remote_autostart = 0',
    'xdebug.remote_connect_back = 1',
    'xdebug.remote_enable = 1',
    'xdebug.remote_handler = "dbgp"',
    'xdebug.remote_port = 9000',
    'xdebug.remote_host = "33.33.33.1"',
    'xdebug.show_local_vars = 1',
    'xdebug.profiler_enable = 0',
    'xdebug.profiler_enable_trigger = 0',
    'xdebug.max_nesting_level = 1000',
    'xdebug.profiler_output_dir = /var/www/'
  ],
  ini     => '/etc/php5/mods-available/custom.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

file { ['/etc/php5/apache2/conf.d/99-custom.ini', '/etc/php5/cli/conf.d/99-custom.ini']:
  ensure => link,
  target => '/etc/php5/mods-available/custom.ini',
  require => Puphpet::Ini['custom']
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
  port          => 8080,
  priority      => '10',
  require       => Class['phpmyadmin'],
}

single_user_rvm::install { 'vagrant':
  require => Gnupg_key['gpg-rvm-signature']
}
single_user_rvm::install_ruby { '2.2':
  user => vagrant
}

exec {'set-default-ruby-for-vagrant':
  user        => vagrant,
  command     => 'bash -c "source ~/.rvm/scripts/rvm; rvm --default use 2.2"',
  environment => ['HOME=/home/vagrant'],
  path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vagrant/.rvm/bin/',
  require     => Single_user_rvm::Install_ruby['2.2']
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
  docroot       => '/usr/share/webgrind-1.2',
  port          => 8080,
  priority      => '10',
  require       => Class['webgrind'],
}

apache::vhost { 'joomla.box':
  server_admin  => 'webmaster@localhost',
  serveraliases => 'localhost',
  port          => 8080,
  priority      => '00',
  docroot       => '/var/www',
  directory     => '/var/www',
  directory_allow_override   => 'All',
  directory_options => 'Indexes FollowSymLinks MultiViews',
  template     => 'apache/virtualhost/joomlatools.vhost.conf.erb',
}

exec { 'disable-default-vhost':
  command => 'a2dissite 000-default',
  require => Apache::Vhost['joomla.box']
}

file { '/etc/apache2/conf-available/shared_paths.conf':
  ensure => file,
  require => Apache::Vhost['joomla.box']
}

exec { 'enable-shared-paths-config':
  command => 'a2enconf shared_paths',
  require => File['/etc/apache2/conf-available/shared_paths.conf']
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
  timeout => 900,
  require => Exec['set-default-ruby-for-vagrant']
}

exec {'install-bundler-gem':
  user    => vagrant,
  command => 'bash -c "source ~/.rvm/scripts/rvm; gem install bundler"',
  environment => ['HOME=/home/vagrant'],
  timeout => 900,
  require => Exec['set-default-ruby-for-vagrant']
}

exec {'install-sass-gem':
  user    => vagrant,
  command => 'bash -c "source ~/.rvm/scripts/rvm; gem install sass compass"',
  environment => ['HOME=/home/vagrant'],
  timeout => 900,
  require => Exec['set-default-ruby-for-vagrant']
}

class { 'box':
  require => [Class['composer'], Class['phpmanager']]
}

class {'wetty': }
class {'cloudcommander': }

file { '/etc/update-motd.d/999-joomlatools':
  ensure => 'present',
  mode   => 'ug+rwx,o+rx',
  source => 'puppet:///modules/motd/joomlatools',
}

file { ['/etc/update-motd.d/10-help-text', '/etc/update-motd.d/91-release-upgrade', '/etc/update-motd.d/50-landscape-sysinfo', '/etc/update-motd.d/51-cloudguest', '/etc/update-motd.d/90-updates-available', '/etc/update-motd.d/98-cloudguest']:
  ensure => absent
}

class { 'pimpmylog':
  require => [Package['apache'], Package['mysql-server']]
}

class { 'phpmetrics':
  require => [Class['composer'], Class['scripts']]
}

package { 'git-ftp':
  require => Apt::Ppa['ppa:resmo/git-ftp']
}

package { 'httpie':
  ensure => latest
}

swap_file::files { 'default':
  ensure   => present,
  swapfilesize => '512 MB'
}

class { 'hhvm':
  manage_repos => true,
  pgsql        => false
}

class {'triggers': }

class { 'varnish': }

class { 'zray':
  notify  => Service['apache'],
  require => Class['php']
}
