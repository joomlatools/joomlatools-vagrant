<?php
namespace Command\Php;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Output\OutputInterface;

class Ini extends Command
{
    protected function configure()
    {
        $this->setName('php:ini')
             ->setDescription('Get or set PHP config directive for the currently active PHP version')
             ->addArgument(
                'key',
                InputArgument::REQUIRED,
                'Name of the directive'
             )->addArgument(
                'value',
                InputArgument::OPTIONAL,
                'Value to set'
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $key   = $input->getArgument('key');
        $value = $input->getArgument('value');

        $current = $this->_getConfigValue($key);

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
                $this->_updateIni($ini, $key, $value);

                `sudo service apache2 restart 2>&1 1> /dev/null`;

                $output->writeln("$key value is now '$value', was '$current'");
            }
            else $output->write('Error: failed to find PHP\'s additional config directory (config-file-scan-dir)!');
        }
        else $output->writeln($current);
    }

    protected function _getConfigValue($key)
    {
        $current = `php -r "\\\$value = ini_get('$key'); echo \\\$value === false ? 'unknown-directive' : \\\$value;"`;

        if ($current == 'unknown-directive') {
            return false;
        }

        return $current;
    }

    protected function _getIniOverride()
    {
        $filelist = `php -r 'echo php_ini_scanned_files();'`;

        if (strpos($filelist, ','))
        {
            $files = explode(',', $filelist);
            $file  = array_shift($files);
            $path  = dirname($file) . DIRECTORY_SEPARATOR . 'zzz_custom.ini';

            if (!file_exists($path)) {
                touch($path);
            }

            return $path;
        }

        return false;
    }

    protected function _updateIni($ini, $key, $value)
    {
        $values = parse_ini_file($ini);
        $values[$key] = $value;

        $string = '';
        foreach($values as $k => $v)
        {
            if (!empty($v) || $v === '0') {
                $string .= "$k = $v" . PHP_EOL;
            }
        }

        `sudo chmod o+rw $ini`;
        file_put_contents($ini, $string);
    }
}