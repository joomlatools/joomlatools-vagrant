<?php
namespace Command\Xdebug;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\ArrayInput;
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

        $files = \Helper\Ini::findIniFiles($this->_ini_files);

        foreach($files as $file) {
            `sudo sed -i 's#^zend_extension=#; zend_extension=#' $file`;
        }

        // Also disable the profiler so we don't spend
        // an afternoon looking for the lack of performance
        // after enabling xdebug again after three weeks. :)
        $files = \Helper\Ini::findIniFiles(array('custom.ini', '99-custom.ini'), false);

        foreach($files as $file) {
            \Helper\Ini::update($file, 'xdebug.profiler_enable', 0);
        }

        $this->getApplication()->find('server:restart')->run(new ArrayInput(array('command' => 'server:restart', 'service' => array('apache'))), $output);

        $output->writeln('Xdebug has been disabled');
    }
}