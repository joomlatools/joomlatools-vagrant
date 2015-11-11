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
             ->setDescription('List all available versions')
            ->setHelp(<<<EOF
To get a list of the PHP versions you can build and install, run this command:

    <info>box php:versions</info>

Use the `<info>box php:use <VERSION></info>` command to build and install one of the available versions.
EOF
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        if (\Helper\System::getEngine() === 'hhvm')
        {
            $output->writeln('<comment>[notice]</comment> You are currently running the HHVM engine');
            $output->writeln('<comment>[notice]</comment> Switch back to the Zend engine to manage Zend PHP versions');

            exit();
        }

        passthru('phpmanager versions');
    }
}