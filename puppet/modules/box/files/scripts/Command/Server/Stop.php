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

        `sudo service apache2 $task`;
        `sudo service mysql $task`;

        $output->writeln('Done');
    }
}