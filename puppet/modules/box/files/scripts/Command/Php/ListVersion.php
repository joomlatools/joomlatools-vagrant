<?php
namespace Command\Php;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class ListVersion extends Command
{
    protected function configure()
    {
        $this->setName('php:list')
             ->setDescription('List all installed PHP versions');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        passthru('phpmanager available');
    }
}