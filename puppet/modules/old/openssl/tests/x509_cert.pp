openssl::certificate::x509 { 'foo.bar':
  ensure       => present,
  country      => 'CH',
  organization => 'Example.com',
  commonname   => $fqdn,
  base_dir     => '/tmp',
  owner        => 'www-data',
  password     => 'mahje1Qu',
}
