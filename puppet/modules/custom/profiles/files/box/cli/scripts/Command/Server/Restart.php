<?php
namespace Command\Server;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class Restart extends Command
{
    protected function configure()
    {
        $this->setName('server:restart')
             ->setDescription('Restart Apache and MySQL')
             ->addArgument(
                 'service',
                 InputArgument::IS_ARRAY,
                 'Service to restart. Can be one or more of: apache|varnish|mysql. Leave empty to restart all services at once.',
                array('apache', 'varnish', 'mysql')
             );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $services = $input->getArgument('service');

        if (!count($services)) {
            $services = array('apache2', 'varnish', 'mysql');
        }

        if (($key = array_search('apache', $services)) !== false) {
            $services[$key] = 'apache2';
        }

        foreach ($services as $service) {
            `sudo service $service restart 2>&1 1> /dev/null`;
        }

        $output->writeln("Server has been restarted");
    }
}