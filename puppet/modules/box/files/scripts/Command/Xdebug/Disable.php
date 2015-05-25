<?php
namespace Command\Xdebug;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Disable extends Xdebug
{
    protected function configure()
    {
        $this->setName('xdebug:disable')
             ->setDescription('Disable Xdebug');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $files = $this->_getConfigFiles($this->_ini_files);

        foreach($files as $file) {
            `sudo sed -i 's#^zend_extension=#; zend_extension=#' $file`;
        }

        `sudo /etc/init.d/apache2 restart`;

        $output->writeln('Done');
    }
}