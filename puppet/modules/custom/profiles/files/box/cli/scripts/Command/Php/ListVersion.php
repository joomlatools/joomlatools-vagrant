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
             ->setDescription('List all installed PHP versions')
            ->setHelp(<<<EOF
To get a list of the PHP versions you have build and installed, run:

    <info>box php:list</info>

Use the `<info>box php:use <VERSION></info>` command to switch to one of the available versions.
EOF
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        passthru('phpmanager available');
    }
}