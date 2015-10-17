<?php
namespace Command\Php;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Output\OutputInterface;

class UseVersion extends Command
{
    protected function configure()
    {
        $this->setName('php:use')
             ->setDescription('Switch to another PHP version. Will attempt to compile from source if not installed.')
            ->addArgument(
                'version',
                InputArgument::REQUIRED,
                'PHP version to remove'
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

        $version = $input->getArgument('version');

        passthru("phpmanager use $version");
    }
}