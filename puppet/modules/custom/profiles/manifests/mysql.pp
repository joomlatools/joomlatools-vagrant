class profiles::mysql(
  $root_password = 'root',
  $mysqld_config = undef
) {

    apt::source { 'mariadb':
        location   => 'http://mariadb.mirror.nucleus.be/repo/10.1/ubuntu',
        repos      => 'main',
        key        => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB'
    }

    class { '::mysql::server':
        package_name     => "mariadb-server",
        root_password    => $root_password,
        override_options => {
          'mysqld' => $mysqld_config
        },
        users => {
          'root@127.0.0.1' => {
            ensure          => 'present',
            password_hash   => mysql_password($root_password)
          }
        },
        grants => {
          'root@127.0.0.1/*.*' => {
            ensure     => 'present',
            options    => ['GRANT'],
            privileges => ['ALL'],
            table      => '*.*',
            user       => 'root@127.0.0.1',
          }
        },
        require => Apt::Source['mariadb'],
    }

    class { '::mysql::client':
        package_name  => 'mariadb-client',
        require       => Class['mysql::server']
    }

}