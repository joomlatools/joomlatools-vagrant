# == Definition: archive::extract
#
# Archive extractor.
#
# Parameters:
#
# - *$target: Destination directory
# - *$src_target: Default value "/usr/src".
# - *$root_dir: Default value "".
# - *$extension: Default value ".tar.gz".
# - *$timeout: Default value 120.
# - *$strip_components: Default value 0.
# - *$user: The user used to do the extraction.
#
# Example usage:
#
#   archive::extract {"apache-tomcat-6.0.26":
#     ensure => present,
#     target => "/opt",
#   }
#
# This means we want to extract the local archive
# (maybe downloaded with archive::download)
# '/usr/src/apache-tomcat-6.0.26.tar.gz' in '/src/apache-tomcat-6.0.26'
#
# Warning:
#
# The parameter *$root_dir* must be used if the root directory of the archive
# is different from the name of the archive *$name*. To extract the name of
# the root directory use the commands "tar tf archive.tar.gz" or
# "unzip -l archive.zip"
#
define archive::extract (
  $target,
  $ensure=present,
  $src_target='/usr/src',
  $root_dir=undef,
  $extension='tar.gz',
  $timeout=120,
  $path=$::path,
  $strip_components=0,
  $purge=false,
  $user=undef,
) {

  if $root_dir {
    $extract_dir = "${target}/${root_dir}"
  } else {
    $extract_dir = "${target}/${name}"
  }

  case $ensure {
    'present': {

      $extract_zip    = "unzip -o ${src_target}/${name}.${extension} -d ${target}"
      $extract_targz  = "tar --no-same-owner --no-same-permissions --strip-components=${strip_components} -xzf ${src_target}/${name}.${extension} -C ${target}"
      $extract_tarbz2 = "tar --no-same-owner --no-same-permissions --strip-components=${strip_components} -xjf ${src_target}/${name}.${extension} -C ${target}"
      $extract_tarxz  = "tar --no-same-owner --no-same-permissions --strip-components=${strip_components} -xpf ${src_target}/${name}.${extension} -C ${target}"

      $purge_command = $purge ? {
        true    => "rm -rf ${target} && ",
        default => '',
      }

      $command = $extension ? {
        'zip'     => "${purge_command}mkdir -p ${target} && ${extract_zip}",
        'tar.gz'  => "${purge_command}mkdir -p ${target} && ${extract_targz}",
        'tgz'     => "${purge_command}mkdir -p ${target} && ${extract_targz}",
        'tar.bz2' => "${purge_command}mkdir -p ${target} && ${extract_tarbz2}",
        'tgz2'    => "${purge_command}mkdir -p ${target} && ${extract_tarbz2}",
        'tar.xz'  => "${purge_command}mkdir -p ${target} && ${extract_tarxz}",
        'txz'     => "${purge_command}mkdir -p ${target} && ${extract_tarxz}",
        default   => fail ( "Unknown extension value '${extension}'" ),
      }
      exec {"${name} unpack":
        command => $command,
        creates => $extract_dir,
        timeout => $timeout,
        user    => $user,
        path    => $path,
      }
    }
    'absent': {
      file {$extract_dir:
        ensure  => absent,
        recurse => true,
        purge   => true,
        force   => true,
      }
    }
    default: { err ( "Unknown ensure value: '${ensure}'" ) }
  }
}
