class profiles::nodejs(
  Array[String] $packages = ['yarn', 'uglify-js@1']
) {

  class { '::nodejs':
    repo_url_suffix => '12.x',
  }

}