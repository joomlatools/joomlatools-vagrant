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

    file { '/etc/update-motd.d/999-joomlatools':
      ensure => 'present',
      mode   => 'ug+rwx,o+rx',
      source => 'puppet:///modules/profiles/motd/joomlatools'
    }

    file { ['/etc/update-motd.d/10-help-text', '/etc/update-motd.d/91-release-upgrade', '/etc/update-motd.d/50-landscape-sysinfo', '/etc/update-motd.d/51-cloudguest', '/etc/update-motd.d/90-updates-available', '/etc/update-motd.d/98-cloudguest']:
      ensure => absent
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

}