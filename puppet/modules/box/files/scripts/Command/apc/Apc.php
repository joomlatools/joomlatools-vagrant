<?php
namespace Command\Apc;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

abstract class Apc extends Command
{
    public static $files;

    protected $_ini_files = array('20-apc.ini', 'zzz_apc.ini', 'zzz_apcu.ini', 'zzz_opcache.ini');

    public function __construct($name = null)
    {
        parent::__construct($name);

        if (!self::$files) {
            self::$files = __DIR__.'../../util';
        }
    }

    protected function _getConfigFiles($basenames = array())
    {
        $inis  = array();
        $paths = array('/etc/php5/conf.d/', '/etc/php5/mods-available/');

        $installs = glob('/opt/php/php-*/etc/conf.d', GLOB_ONLYDIR);
        $installs = array_unique(array_filter($installs));

        $paths = array_merge($paths, $installs);

        foreach($paths as $path)
        {
            foreach($basenames as $basename)
            {
                $fullpath = $path . '/' . $basename;
                if(file_exists($fullpath)) {
                    $inis[] = $fullpath;
                }
            }
        }

        return $inis;
    }
}