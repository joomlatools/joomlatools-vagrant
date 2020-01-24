class profiles::mysql(
  $root_password = 'root',
  $mysqld_config = {}
) {

    $default_mysqld_config = {
      'default-storage-engine'   => 'InnoDB',
      'bind-address'             => '*',
      'sql-mode'                 => 'ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION',
      'character-set-server'     => 'utf8',
      'collation-server'         => 'utf8_general_ci'
    }

    $mysqld_options = merge($default_mysqld_config, $mysqld_config)

    # Little workaround to deal with apt failing to retrieve
    # GPG keys from the keyservers.
    # It fails randomly on different machines and using a different
    # key server didn't solve it either.
    #
    # Errors received are either
    # - gpg: keyserver receive failed: Invalid argument
    # - gpg: keyserver receive failed: Server indicated a failure
    exec { 'download-mariadb-gpg-key':
      command => '/usr/bin/wget https://keyserver.ubuntu.com/pks/lookup?op=get\&search=0x177F4010FE56CA3336300305F1656F24C74CD1D8 -O /tmp/mariadb.gpg.key && apt-key add /tmp/mariadb.gpg.key',
      unless => 'apt-key list 2> /dev/null | grep mariadb'
    }

    apt::source { 'mariadb':
        location   => 'http://ams2.mirrors.digitalocean.com/mariadb/repo/10.4/ubuntu',
        repos      => 'main',
        architecture => 'amd64',
        require    => Exec['download-mariadb-gpg-key']
    }

    class { '::mysql::server':
        package_name     => mariadb-server,
        package_ensure   => latest,
        root_password    => $root_password,
        override_options => {
          'mysqld' => $mysqld_options
        },
        users => {
          'root@%' => {
            ensure          => 'present',
            password_hash   => mysql_password($root_password)
          }
        },
        grants => {
          'root@%/*.*' => {
            ensure     => 'present',
            options    => ['GRANT'],
            privileges => ['ALL'],
            table      => '*.*',
            user       => 'root@%',
          }
        },
        require => Apt::Source['mariadb'],
    }

    class { '::mysql::client':
        package_name  => mariadb-client,
        require       => Class['mysql::server']
    }

}