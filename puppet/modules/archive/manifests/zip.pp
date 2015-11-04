# See README.md for details.
define archive::zip($source, $target, $path = $::path) {
  exec {"${name} unpack":
    command => "TMPFILE=\$(mktemp); curl -s -S -o \${TMPFILE}.zip ${source} && unzip \${TMPFILE}.zip -d ${target} && rm \$TMPFILE && rm \${TMPFILE}.zip && touch ${name}",
    creates => $name,
    path    => $::path,
    require => Package['unzip'],
  }
}
