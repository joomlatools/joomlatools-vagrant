<?php
namespace Command\Server;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class Restart extends Command
{
    private static $__services = array('apache', 'varnish', 'mysql', 'php', 'nginx');

    protected function configure()
    {
        $this->setName('server:restart')
             ->setDescription('Restart Apache and MySQL')
             ->addArgument(
                 'service',
                 InputArgument::IS_ARRAY,
                 'Service to restart. Valid values: apache, php, varnish, nginx or mysql. Leave empty to restart all services at once.',
                 self::$__services
             );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $services = $input->getArgument('service');

        if (!count($services)) {
            $services = self::$__services;
        }

        foreach ($services as $key => $service)
        {
            if (!in_array($service, self::$__services)) {
                unset($services[$key]);
            }
        }

        if (($key = array_search('apache', $services)) !== false) {
            $services[$key] = 'apache2';
        }

        if (($key = array_search('php', $services)) !== false) {
            $services[$key] = 'php-fpm';
        }

        foreach ($services as $service) {
            `sudo service $service restart 2>&1 1> /dev/null`;
        }

        $output->writeln("Server has been restarted");
    }
}