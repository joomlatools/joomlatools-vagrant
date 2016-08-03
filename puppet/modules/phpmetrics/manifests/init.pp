class phpmetrics {

    file { '/usr/share/phpmetrics':
        ensure => directory,
        owner  => vagrant
    }

    exec {'install-phpmetrics':
        command => 'composer require halleck45/phpmetrics --no-interaction',
        cwd     => '/usr/share/phpmetrics',
        unless  => '[ -d /usr/share/phpmetrics/vendor/halleck45 ]',
        user    => vagrant,
        environment => 'COMPOSER_HOME=/home/vagrant/.composer',
        require => File['/usr/share/phpmetrics']
    }

    exec { 'add-phpmetrics-to-path':
        command => 'echo "export PATH=\$PATH:/usr/share/phpmetrics/vendor/bin" >> /home/vagrant/.bash_profile',
        unless  => 'grep ":/usr/share/phpmetrics/vendor/bin" /home/vagrant/.bash_profile',
        user    => vagrant,
        require => Exec['install-phpmetrics']
    }

}