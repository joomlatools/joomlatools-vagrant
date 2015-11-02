define composer::run (
  $path,
  $command = 'install'
) {

  include composer

  exec { "composer-${path}-${command}-${composer::composer_location}":
    command => "${composer::composer_filename} ${command} --working-dir ${path}",
    path    => "/usr/bin:/usr/sbin:/bin:/sbin:${composer::composer_location}",
  }
}
