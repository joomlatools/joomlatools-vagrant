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
             ->setDescription('Stop Apache and MySQL')
             ->addOption(
                'restart',
                null,
                InputOption::VALUE_NONE,
                "Restart the services instead of stopping them."
             );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $task = $input->getOption('restart') ? 'restart' : 'stop';
        $txt  = $task == 'stop' ? 'stopped' : 'restarted';

        `sudo service apache2 $task 2>&1 1> /dev/null`;
        `sudo service mysql $task 2>&1 1> /dev/null`;

        $output->writeln("Server has been $txt");
    }
}