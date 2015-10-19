<?php
namespace Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class Restore extends Command
{
    protected function configure()
    {
        $this->setName('restore')
             ->setDescription('Restore the MySQL databases and Apache2 virtual hosts')
             ->addOption('archive', 'a', InputOption::VALUE_REQUIRED, 'Full path to backup archive', '/vagrant/joomla-box-backup.tar');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $archive = $input->getOption('archive');

        if (!file_exists($archive)) {
            throw new \RuntimeException('Failed to find backup archive ' . $archive);
        }

        passthru("/bin/bash /home/vagrant/triggers/restore.sh $archive");
    }
}