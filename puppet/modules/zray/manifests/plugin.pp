define zray::plugin(
  $archive           = undef,
  $archive_root_dir  = undef,
  $archive_extension = 'zip',
  $install_directory = '/opt/zray/runtime/var/plugins',
  $install_directory_user  = 'www-data',
  $install_directory_group = 'www-data',
) {

  if ($archive == undef) {
    fail("${title} needs a valid download URL")
  }

  if $archive_root_dir {
    $root_dir = $archive_root_dir
  } else {
    $root_dir = $title
  }

  archive { $title:
    ensure           => present,
    url              => $archive,
    target           => $install_directory,
    checksum         => false,
    root_dir         => $root_dir,
    extension        => $archive_extension,
    follow_redirects => true
  }

  exec { "${title}-chown":
    command => "/usr/bin/find $install_directory ! -user ${install_directory_user} -exec /bin/chown ${install_directory_user}:${install_directory_group} {} \\;",
    require => Archive[$title]
  }

}