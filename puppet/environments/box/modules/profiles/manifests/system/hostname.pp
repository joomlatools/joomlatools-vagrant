define profiles::system::hostname(
  $ip = $::ipaddress
){
  $alias = regsubst($name, '^([^.]*).*$', '\1')

  if ($::hostname != $name)
  {
    host { "${::hostname}":
      ensure => absent
    }
  }

  host { "$name":
    ensure => present,
    ip     => $ip,
    alias  => $alias ? {
      "$hostname" => undef,
      default     => $alias
    },
    before => Exec['set-hostname'],
  }

  file { '/etc/mailname':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "${name}\n",
  }

  file { '/etc/hostname':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "${name}\n",
    notify  => Exec['set-hostname'],
  }

  exec { 'set-hostname':
    command => "/usr/bin/hostnamectl set-hostname ${name}",
    refreshonly => true
  }
}