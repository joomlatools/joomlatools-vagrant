group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ], timeout => 900 }
File { owner => 0, group => 0, mode => 0644 }


class { 'zray':


}
