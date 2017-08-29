define profiles::zray::php::ini (
  $ensure      = present,
  $path        = '/opt/zray',
  $enable      = false
) {

  file { "/etc/php5/mods-available/${title}.ini":
    ensure  => $ensure,
    content => template('profiles/zray/php.ini.erb')
  }

  if ($enable) {
    file { "/etc/php5/apache2/conf.d/20-${title}.ini":
      ensure => link,
      target => "/etc/php5/mods-available/${title}.ini"
    }
  }
  else {
    file { ["/etc/php5/apache2/conf.d/20-${title}.ini"]:
      ensure => absent
    }
  }

}