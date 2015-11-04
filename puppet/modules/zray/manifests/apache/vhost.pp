define zray::apache::vhost (
  $ensure      = present,
  $path        = '/opt/zray',
  $enable      = false
) {

  file { "/etc/apache2/sites-available/00-${title}.conf":
    ensure  => $ensure,
    content => template('zray/apache.vhost.erb')
  }

  if ($enable) {
    file { "/etc/apache2/sites-enabled/00-${title}.conf":
      ensure => link,
      target => "/etc/apache2/sites-available/00-${title}.conf"
    }
  }


}