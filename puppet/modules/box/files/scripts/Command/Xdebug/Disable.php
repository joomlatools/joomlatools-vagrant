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
        parent::execute($input, $output);

        $files = $this->_getConfigFiles($this->_ini_files);

        foreach($files as $file) {
            `sudo sed -i 's#^zend_extension=#; zend_extension=#' $file`;
        }

        `sudo service apache2 restart 2>&1 1> /dev/null`;

        $output->writeln('Xdebug has been disabled');
    }
}