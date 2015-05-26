<?php
namespace Command\Php;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Reset extends Command
{
    protected function configure()
    {
        $this->setName('php:reset')
             ->setDescription('Switch back to the default system PHP');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        passthru('phpmanager restore');
    }
}