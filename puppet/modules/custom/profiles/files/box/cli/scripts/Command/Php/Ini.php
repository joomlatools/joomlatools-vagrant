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
             ->setHelp(<<<EOF
To retrieve a value from the currently installed PHP version, you can use the `box php:ini <directive>` command. For example, to get the current `mysql.default_socket` value:

    <info>box php:ini mysql.default_socket</info>

To change this value into something else, append the new value:

    <info>box php:ini mysql.default_socket /path/to/new/socket</info>

The script puts these directives into an additional config file that overrides the default values. To remove the directive again, pass in an empty value:

    <info>box php:ini mysql.default_socket ""</info>

If you want to get the list of the scanned .ini files, run the command without arguments:

    <info>box php:ini</info>
EOF
             )
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

                $this->getApplication()->find('server:restart')->run(new ArrayInput(array('command' => 'server:restart', 'service' => array('php'))), $output);

                $output->writeln("$key value is now <info>$value</info>, was <info>$current</info>");
            }
            else $output->write('Error: failed to find PHP\'s additional config directory (config-file-scan-dir)!');
        }
        else $output->writeln("$key value is <info>$current</info>");
    }

    protected function _getIniOverride()
    {
        $bin = \Helper\System::getPHPCommand();
        $filelist = `$bin -r 'echo php_ini_scanned_files();'`;

        if (strpos($filelist, ','))
        {
            $files = explode(',', $filelist);
            $file  = array_shift($files);
            $path  = dirname($file) . DIRECTORY_SEPARATOR . '99-custom.ini';

            // Special case: oru default PHP installation
            // separates INI files per SAPI (cli/fpm).
            // If we're on the default PHP version, make sure use the INI file
            // in the mods-available directory
            $isDefault = false;
            if (preg_match('#^/etc/php/\d\.\d/cli/conf.d/#', $path))
            {
                $isDefault = true;
                $path      = str_replace('cli/conf.d/99-', 'mods-available/', $path);
            }

            if (!file_exists($path))
            {
                `echo "; priority=99" | sudo tee $path`;

                if ($isDefault) {
                    `sudo phpenmod -s ALL custom`;
                }
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