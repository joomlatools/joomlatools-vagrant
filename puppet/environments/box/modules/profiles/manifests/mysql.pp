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

    apt::source { 'mariadb':
        location   => 'http://mariadb.mirror.nucleus.be/repo/10.4/ubuntu',
        repos      => 'main',
        key        => '177F4010FE56CA3336300305F1656F24C74CD1D8'
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