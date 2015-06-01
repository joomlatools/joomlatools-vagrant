<?php
namespace Command\Php;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Versions extends Command
{
    protected function configure()
    {
        $this->setName('php:versions')
             ->setDescription('List all available versions');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        passthru('phpmanager versions');
    }
}