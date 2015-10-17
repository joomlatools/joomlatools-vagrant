<?php
namespace Command\Apc;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Output\OutputInterface;

class Enable extends Apc
{
    protected function configure()
    {
        $this->setName('apc:enable')
             ->setDescription('Enable APC');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $files = $this->_getConfigFiles($this->_ini_files);

        foreach($files as $file) {
            \Helper\Ini::update($file, 'apc.enabled', '1');
        }

        $this->getApplication()->find('server:restart')->run(new ArrayInput(array('command' => 'server:restart')), $output);

        $output->writeln('APC has been enabled');
    }
}