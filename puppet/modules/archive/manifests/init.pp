# == Definition: archive
#
# Download and extract an archive.
#
# Parameters:
#
# - *$url:
# - *$target: Destination directory
# - *$purge_target: Purge Destination prior to extraction. Default false
# - *$checksum: Default value "true"
# - *$digest_url: Default value undef
# - *$digest_string: Default value undef
# - *$digest_type: Default value "md5"
# - *$src_target: Default value "/usr/src"
# - *$root_dir: Default value undef
# - *$extension: Default value ".tar.gz"
# - *$timeout: Default value 120
# - *$allow_insecure: Default value false
# - *$follow_redirects: Default value false
# - *$verbose: Default value true
# - *$strip_components: Default value 0
# - *$proxy_server: Default value undef
# - *$user: User used to do the download and the extraction. The final directory will be used by him/her.
#
# Example usage:
#
#   archive {"apache-tomcat-6.0.26":
#     ensure => present,
#     url    => "http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.26/bin/apache-tomcat-6.0.26.tar.gz",
#     target => "/opt",
#   }
#
define archive (
  $url,
  $target,
  $ensure=present,
  $checksum=true,
  $digest_url=undef,
  $digest_string=undef,
  $digest_type='md5',
  $timeout=120,
  $root_dir=undef,
  $extension='tar.gz',
  $src_target='/usr/src',
  $allow_insecure=false,
  $follow_redirects=false,
  $verbose=true,
  $strip_components=0,
  $proxy_server=undef,
  $purge_target=false,
  $user=undef,
) {

  archive::download {"${name}.${extension}":
    ensure           => $ensure,
    url              => $url,
    checksum         => $checksum,
    digest_url       => $digest_url,
    digest_string    => $digest_string,
    digest_type      => $digest_type,
    timeout          => $timeout,
    src_target       => $src_target,
    allow_insecure   => $allow_insecure,
    follow_redirects => $follow_redirects,
    verbose          => $verbose,
    proxy_server     => $proxy_server,
    user             => $user,
  }

  archive::extract {$name:
    ensure           => $ensure,
    target           => $target,
    purge            => $purge_target,
    src_target       => $src_target,
    root_dir         => $root_dir,
    extension        => $extension,
    timeout          => $timeout,
    strip_components => $strip_components,
    require          => Archive::Download["${name}.${extension}"],
    user             => $user,
  }
}
