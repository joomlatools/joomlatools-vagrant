class uglifyjs {
  class {"uglifyjs::install": }
}

class uglifyjs::install {
  include nodejs

  exec { 'npm-install-uglify-js':
      command => 'npm install -g uglify-js@1',
      unless  => 'which uglifyjs',
      require => Package['nodejs'],
  }
}