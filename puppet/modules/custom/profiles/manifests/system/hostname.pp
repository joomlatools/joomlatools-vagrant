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
    before => Exec['service hostname restart'],
  }

  file { '/etc/mailname':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    content => "${name}\n",
  }

  file { '/etc/hostname':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    content => "${name}\n",
    notify  => Exec['service hostname restart'],
  }

  exec { 'service hostname restart':
    refreshonly => true
  }
}