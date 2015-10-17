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
        if (\Helper\System::getEngine() === 'hhvm')
        {
            $output->writeln('<comment>[notice]</comment> You are currently running the HHVM engine');
            $output->writeln('<comment>[notice]</comment> Switch back to the Zend engine to manage Zend PHP versions');

            exit();
        }

        passthru('phpmanager available');
    }
}