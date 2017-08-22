class profiles::mysql(
  $root_password = 'root',
  $mysqld_config = {'bind-address' => '*'}
) {

    apt::source { 'mariadb':
        location   => 'http://mariadb.mirror.nucleus.be/repo/10.2/ubuntu',
        repos      => 'main',
        key        => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB'
    }

    class { '::mysql::server':
        package_name     => mariadb-server,
        package_ensure   => latest,
        root_password    => $root_password,
        override_options => {
          'mysqld' => $mysqld_config
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