<?php
namespace Command\Php;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class Ini extends Command
{
    protected function configure()
    {
        $this->setName('php:ini')
             ->setDescription('Get or set PHP config directive for the currently active PHP version')
             ->addArgument(
                'key',
                InputArgument::OPTIONAL,
                'Name of the directive to lookup or update'
             )->addArgument(
                'value',
                InputArgument::OPTIONAL,
                'New value'
            )->addOption(
                'list-files',
                'l',
                InputOption::VALUE_NONE
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $key   = $input->getArgument('key');
        $value = $input->getArgument('value');

        if ($input->getOption('list-files') || empty($key)) {
            $this->_listIniFiles();
        }

        if (empty($key)) {
            return;
        }

        $current = \Helper\Ini::getPHPConfig($key);

        if ($current === false)
        {
            $output->writeln("Unknown key '$key'");

            return;
        }

        if (empty($current)) {
            $current = 'no value (0 or empty string)';
        }

        if (!is_null($value))
        {
            $ini = $this->_getIniOverride();

            if ($ini !== false)
            {
                \Helper\Ini::update($ini, $key, $value);

                $this->getApplication()->find('server:restart')->run(new ArrayInput(array('command' => 'server:restart')), $output);

                $output->writeln("$key value is now <info>$value</info>, was <info>$current</info>");
            }
            else $output->write('Error: failed to find PHP\'s additional config directory (config-file-scan-dir)!');
        }
        else $output->writeln("$key value is <info>$current</info>");
    }

    protected function _getIniOverride()
    {
        if (\Helper\System::getEngine() === 'hhvm') {
            return '/etc/hhvm/php.ini';
        }

        $bin = \Helper\System::getPHPCommand();
        $filelist = `$bin -r 'echo php_ini_scanned_files();'`;

        if (strpos($filelist, ','))
        {
            $files = explode(',', $filelist);
            $file  = array_shift($files);
            $path  = dirname($file) . DIRECTORY_SEPARATOR . '99-custom.ini';

            if (!file_exists($path)) {
                touch($path);
            }

            return $path;
        }

        return false;
    }

    protected function _listIniFiles()
    {
        $bin      = \Helper\System::getPHPCommand();
        $filelist = `$bin -r 'echo php_ini_scanned_files();'`;

        if (strpos($filelist, ','))
        {
            $files = explode(',', $filelist);

            foreach ($files as $file) {
                echo trim($file) . PHP_EOL;
            }
        }

        return false;
    }
}