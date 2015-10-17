<?php
namespace Command\Server;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Start extends Command
{
    protected function configure()
    {
        $this->setName('server:start')
             ->setDescription('Start Apache and MySQL');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        `sudo service apache2 start 2>&1 1> /dev/null`;
        `sudo service mysql start 2>&1 1> /dev/null`;

        if (\Helper\System::getEngine() === 'hhvm') {
            `sudo service hhvm start  2>&1 1> /dev/null`;
        }

        $output->writeln('Server has been started');
    }
}