system::hostname { 'joomlatools':
  ip => '127.0.1.1'
}

host { 'joomla.box':
  ip => '127.0.1.1'
}

file { '/etc/profile.d/joomlatools-box.sh':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => 644,
  content => "export JOOMLATOOLS_BOX=${::box_version}\n",
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

exec { "composer-plugin-prestissimo":
  command => "composer global require hirak/prestissimo",
  path    => ['/usr/bin' , '/bin'],
  creates => '/home/vagrant/.composer/vendor/hirak/prestissimo',
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
    'xdebug.profiler_output_dir = /var/www/',
    'openssl.cafile = /etc/ssl/certs/ca-certificates.crt',
    'openssl.capath = /usr/lib/ssl/'
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

class { 'phpmyadmin':
  require => [Class['mysql::server'], Class['mysql::config'], Class['php']],
}

apache::vhost { 'phpmyadmin':
  server_name   => 'phpmyadmin',
  serveraliases => 'phpmyadmin.joomla.box',
  docroot       => '/usr/share/phpmyadmin',
  port          => 8080,
  priority      => '10',
  template      => 'apache/virtualhost/vhost-no-zray.conf.erb',
  require       => Class['phpmyadmin']
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
  template      => 'apache/virtualhost/vhost-no-zray.conf.erb',
  require       => Class['webgrind']
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