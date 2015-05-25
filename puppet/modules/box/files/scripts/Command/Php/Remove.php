<?php
namespace Command\Php;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Output\OutputInterface;

class Remove extends Command
{
    protected function configure()
    {
        $this->setName('php:remove')
             ->setDescription('Uninstall a PHP version')
             ->addArgument(
                'version',
                InputArgument::REQUIRED,
                'PHP version to remove'
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $version = $input->getArgument('version');

        passthru("phpmanager remove $version");
    }
}