
apt::ppa { 'ppa:resmo/git-ftp': }


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