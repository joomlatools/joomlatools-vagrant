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
        `sudo service apache2 start`;
        `sudo service mysql start`;

        $output->writeln('Done');
    }
}