<?php
namespace Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class Backup extends Command
{
    protected function configure()
    {
        $this->setName('backup')
             ->setDescription('Backup the MySQL databases and Apache2 virtual hosts')
            ->addOption('archive', 'a', InputOption::VALUE_REQUIRED, 'Full path to backup archive', '/vagrant/joomla-box-backup.tar');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $archive = $input->getOption('archive');

        if ((file_exists($archive) && !is_writable($archive)) || !is_writable(dirname($archive))) {
            throw new \RuntimeException('Backup destination ' . $archive . ' is not writable.');
        }

        $output->writeln('Creating backup archive <comment>' . basename($archive) . '</comment>');

        passthru("/bin/bash /home/vagrant/triggers/backup.sh $archive");
    }
}