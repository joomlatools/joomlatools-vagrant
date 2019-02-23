define profiles::php::ini (
  $value    = '',
  $ini      = undef,
  $template = 'extra-ini.erb',
) {

  validate_string($ini)

  file { $ini:
    ensure  => present,
    content => template("php/${template}"),
  }

}