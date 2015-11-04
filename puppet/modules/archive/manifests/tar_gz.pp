# See README.md for details.
define archive::tar_gz($source, $target, $path=$::path) {
  exec {"${name} unpack":
    command => "curl -s -S ${source} | tar -xzf - -C ${target} && touch ${name}",
    creates => $name,
    path    => $path,
    require => Package[curl],
  }
}
