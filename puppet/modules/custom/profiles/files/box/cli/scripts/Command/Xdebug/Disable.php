<?php
namespace Command\Xdebug;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Output\NullOutput;

class Disable extends Xdebug
{
    protected function configure()
    {
        $this->setName('xdebug:disable')
             ->setDescription('Disable Xdebug');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        if (!extension_loaded('xdebug'))
        {
            $output->writeln('[<comment>notice</comment>] XDebug is already disabled');
            exit();
        }

        // Also disable the profiler so we don't spend
        // an afternoon looking for the lack of performance
        // after enabling xdebug again after three weeks. :)
        $this->getApplication()->find('xdebug:profiler')->run(new ArrayInput(array('command' => 'xdebug:profiler', 'action' => 'stop')), new NullOutput());

        $files = \Helper\Ini::findIniFiles($this->_ini_files);

        foreach($files as $file) {
            `sudo sed -i 's#^zend_extension=#; zend_extension=#' $file`;
        }

        $this->getApplication()->find('server:restart')->run(new ArrayInput(array('command' => 'server:restart', 'service' => array('php'))), new NullOutput());

        $output->writeln('Xdebug has been disabled');
    }
}