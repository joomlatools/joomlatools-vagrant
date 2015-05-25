<?php
namespace Command\Apc;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Clear extends Apc
{
    protected function configure()
    {
        $this->setName('apc:disable')
             ->setDescription('Disable APC');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $files = $this->_getConfigFiles($this->_ini_files);

        foreach($files as $file) {
            `sudo sed -i 's#^extension=#; extension=#' $file`;
        }

        `sudo /etc/init.d/apache2 restart`;

        $output->writeln('Done');
    }
}