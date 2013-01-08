name 'default'
description 'Default server for Joomlatools development.'

run_list %w(
  recipe[apt]
  recipe[apache2]
  recipe[mysql::server]
  recipe[php]
  recipe[php-custom]
)

override_attributes(
  :mysql => {
    :bind_address => '0.0.0.0',
    :allow_remote_root => true,
    :server_root_password => 'root',
    :server_repl_password => 'root',
    :server_debian_password => 'root'
  },
  :php => {
    :directives => {
      :display_errors => 'On'
    },
    :xdebug => {
      :directives => {
        :remote_autostart => 1,
        :remote_enable => 1,
        :remote_host => '192.168.50.10',
        :remote_port => 9001
      }
    }
  }
)