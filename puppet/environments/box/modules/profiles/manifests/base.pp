class profiles::base {

    # include '::gnupg'

    Apt::Ppa <| |>
      -> Package <| title != 'software-properties-common' |>

    Apt::Source <| |>
      -> Package <| title != 'software-properties-common' |>

    package { [
        'build-essential',
        'curl',
        'git',
        'symlinks',
        'screen',
        'unzip',
        'vim',
        'zip'
    ]:
    ensure  => latest
    }

    include ::apt

    user { 'vagrant': }

    file { '/home/vagrant/.bash_aliases':
      ensure => 'present',
      owner  => vagrant,
      group  => vagrant,
      source => 'puppet:///modules/profiles/shell/bash_aliases',
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

    profiles::system::hostname { 'joomlatools':
      ip => '127.0.0.1'
    }

    host { 'joomla.box':
      ip => '127.0.1.1'
    }

    file { '/etc/update-motd.d/':
      ensure  => directory,
      source  => 'puppet:///modules/profiles/motd/',
      recurse => true,
      purge   => true
    }

    file { '/etc/profile.d/joomlatools-box.sh':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "export JOOMLATOOLS_BOX=${::box_version}\n",
    }

    ssh_keygen { 'vagrant':
      home    => '/home/vagrant',
    }

    exec { 'enable ntp sync':
      command => 'timedatectl set-ntp true && systemctl restart systemd-timesyncd',
      onlyif => 'timedatectl status | grep "systemd-timesyncd.service active: no"',
      path => ['/bin', '/usr/bin']
    }

}