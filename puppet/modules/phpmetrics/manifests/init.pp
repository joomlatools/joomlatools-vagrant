class phpmetrics {

    exec {'install-phpmetrics':
        command => 'composer global require halleck45/phpmetrics --no-interaction',
        cwd     => '/home/vagrant/',
        unless  => '[ -d /home/vagrant/.composer/vendor/halleck45 ]',
        user    => vagrant,
        environment => 'COMPOSER_HOME=/home/vagrant/.composer'
    }

}