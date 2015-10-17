<?php
namespace Command\Server;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class Stop extends Command
{
    protected function configure()
    {
        $this->setName('server:stop')
             ->setDescription('Stop Apache and MySQL');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        `sudo service apache2 stop 2>&1 1> /dev/null`;
        `sudo service mysql stop 2>&1 1> /dev/null`;

        if (\Helper\System::getEngine() === 'hhvm') {
            `sudo service hhvm stop  2>&1 1> /dev/null`;
        }

        $output->writeln("Server has been stopped");
    }
}