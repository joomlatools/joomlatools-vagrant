<?php
namespace Command\Server;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class Restart extends Command
{
    protected function configure()
    {
        $this->setName('server:restart')
             ->setDescription('Restart Apache and MySQL');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        `sudo service varnish restart 2>&1 1> /dev/null`;
        `sudo service apache2 restart 2>&1 1> /dev/null`;
        `sudo service mysql restart 2>&1 1> /dev/null`;

        if (\Helper\System::getEngine() === 'hhvm') {
            `sudo service hhvm restart  2>&1 1> /dev/null`;
        }

        $output->writeln("Server has been restarted");
    }
}