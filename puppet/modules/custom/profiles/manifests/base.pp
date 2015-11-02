class profiles::base {

    Apt::Ppa <| |>
      -> Package <| title != 'software-properties-common' |>

    Apt::Source <| |>
      -> Package <| title != 'software-properties-common' |>

    Package['libaugeas-ruby']
      -> Augeas <| |>

    package { [
        'curl',
        'git-core',
        'libaugeas-ruby',
        'unzip',
        'vim',
        'zip'
    ]:
    ensure  => 'installed'
    }

    class {'apt':
      always_apt_update => true,
    }

    # Fix the locale errors
    exec { 'fix-missing-locale':
      command   => '/usr/sbin/locale-gen en_US.UTF-8 && echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale',
      unless  => 'grep "LC_ALL=" /etc/default/locale',
    }

    swap_file::files { 'default':
      ensure   => present,
      swapfilesize => '512 MB'
    }

}