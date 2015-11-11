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
            ->setHelp(<<<EOF
You can build and install any PHP version from 5.2.0 and up automatically. This is ideal to try out your code on new PHP releases or to fix bugs that have been reported on older PHP versions.
To install one of the available versions, for example 7.0.0RC6, execute:

    <info>box php:use 7.0.0RC6</info>

The script will check if this version has been installed and if not, will attempt to build it. Please note that building PHP might take a while.

You can get a list of buildable versions using the `<info>box php:versions</info>` command. To see what is already compiled and available, use the `<info>box php:list</info>` command.

To revert back to the default PHP installation, run `<info>box php:reset</info>`.

The truly adventurous can build the current master branch with this command: `<info>box php:use master</info>`.
Each time you build the master branch the script will pull in the latest changes from the PHP Git repository.
EOF
            )
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