define hhvm::config::setting(
  $key,
  $value,
  $file,
) {

  if $caller_module_name != $module_name {
    warning("${name} is not part of the public API of the ${module_name} module and should not be directly included in the manifest.")
  }

  validate_string($file)

  $split_name = split($key, '/')
  if count($split_name) == 1 {
    $section = ''
    $setting = $split_name[0]
  } else {
    $section = $split_name[0]
    $setting = $split_name[1]
  }

  ini_setting { $name:
    value   => $value,
    path    => $file,
    section => $section,
    setting => $setting
  }
}
