# == Definition: openssl::certificate::x509
#
# Creates a certificate, key and CSR according to datas provided.
#
# === Parameters
#  [*ensure*]         ensure wether certif and its config are present or not
#  [*country*]        certificate countryName
#  [*state*]          certificate stateOrProvinceName
#  [*locality*]       certificate localityName
#  [*commonname*]     certificate CommonName
#  [*altnames*]       certificate subjectAltName.
#                     Can be an array or a single string.
#  [*organization*]   certificate organizationName
#  [*unit*]           certificate organizationalUnitName
#  [*email*]          certificate emailAddress
#  [*days*]           certificate validity
#  [*base_dir*]       where cnf, crt, csr and key should be placed.
#                     Directory must exist
#  [*owner*]          cnf, crt, csr and key owner. User must exist
#  [*group*]          cnf, crt, csr and key group. Group must exist
#  [*password*]       private key password. undef means no passphrase 
#                     will be used to encrypt private key.
#  [*force*]          whether to override certificate and request
#                     if private key changes
#  [*cnf_tpl*]        Specify an other template to generate ".cnf" file.
#
# === Example
#
#   openssl::certificate::x509 { 'foo.bar':
#     ensure       => present,
#     country      => 'CH',
#     organization => 'Example.com',
#     commonname   => $fqdn,
#     base_dir     => '/var/www/ssl',
#     owner        => 'www-data',
#   }
#
# This will create files "foo.bar.cnf", "foo.bar.crt", "foo.bar.key"
# and "foo.bar.csr" in /var/www/ssl/.
# All files will belong to user "www-data".
#
# Those files can be used as is for apache, openldap and so on.
#
# === Requires
#
#   - `puppetlabs/stdlib`
#
define openssl::certificate::x509(
  $country,
  $organization,
  $commonname,
  $ensure = present,
  $state = undef,
  $locality = undef,
  $unit = undef,
  $altnames = [],
  $email = undef,
  $days = 365,
  $base_dir = '/etc/ssl/certs',
  $owner = 'root',
  $group = 'root',
  $password = undef,
  $force = true,
  $cnf_tpl = 'openssl/cert.cnf.erb',
  ) {

  validate_string($name)
  validate_string($country)
  validate_string($organization)
  validate_string($commonname)
  validate_string($ensure)
  validate_string($state)
  validate_string($locality)
  validate_string($unit)
  validate_array($altnames)
  validate_string($email)
  # lint:ignore:only_variable_string
  validate_string("${days}")
  validate_re("${days}", '^\d+$')
  # lint:endignore
  validate_string($base_dir)
  validate_absolute_path($base_dir)
  validate_string($owner)
  validate_string($group)
  validate_string($password)
  validate_bool($force)
  validate_re($ensure, '^(present|absent)$',
    "\$ensure must be either 'present' or 'absent', got '${ensure}'")
  validate_string($cnf_tpl)

  file {"${base_dir}/${name}.cnf":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    content => template($cnf_tpl),
  }

  ssl_pkey { "${base_dir}/${name}.key":
    ensure   => $ensure,
    password => $password,
  }

  x509_cert { "${base_dir}/${name}.crt":
    ensure      => $ensure,
    template    => "${base_dir}/${name}.cnf",
    private_key => "${base_dir}/${name}.key",
    days        => $days,
    password    => $password,
    force       => $force,
    require     => File["${base_dir}/${name}.cnf"],
  }

  x509_request { "${base_dir}/${name}.csr":
    ensure      => $ensure,
    template    => "${base_dir}/${name}.cnf",
    private_key => "${base_dir}/${name}.key",
    password    => $password,
    force       => $force,
    require     => File["${base_dir}/${name}.cnf"],
  }

  # Set owner of all files
  file {
    "${base_dir}/${name}.key":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      mode    => '0600',
      require => Ssl_pkey["${base_dir}/${name}.key"];

    "${base_dir}/${name}.crt":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      require => X509_cert["${base_dir}/${name}.crt"];

    "${base_dir}/${name}.csr":
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      require => X509_request["${base_dir}/${name}.csr"];
  }
}
