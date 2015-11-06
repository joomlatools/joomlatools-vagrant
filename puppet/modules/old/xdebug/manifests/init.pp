class xdebug (
  $service = 'apache'
){

  package { 'xdebug':
    name    => 'php5-xdebug',
    ensure  => installed,
    require => Package['php'],
    notify  => Service[$service],
  }

  file { '/etc/php5/mods-available/xdebug.ini':
    ensure  => file,
    content => '; zend_extension=xdebug.so',
    require => Package['xdebug'],
    notify  => Service[$service]
  }

}
