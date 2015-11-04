<?php
namespace Command\Zray;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

abstract class Zray extends Command
{
    protected $_ini_files = array('zray-php5.5.ini', 'zray-php5.6.ini');

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        if (\Helper\System::getEngine() === 'hhvm')
        {
            $output->writeln("<comment>[warning]</comment> Engine is set to <info>hhvm</info>. No changes will be made.");
            $output->writeln("<comment>[warning]</comment> Switch back to the Zend engine if you want to use Zend Server Z-Ray");

            exit();
        }

        $version = \Helper\System::getZendPHPVersion();
        $major   = substr($version, 0, 3);

        if (!in_array($major, array('5.5', '5.6')))
        {
            $output->writeln("<comment>[warning]</comment> <info>Zend Server Z-Ray</info> is only supported on PHP 5.5 and 5.6.");
            $output->writeln("<comment>[warning]</comment> Your current version is PHP $version");

            exit();
        }
    }
}