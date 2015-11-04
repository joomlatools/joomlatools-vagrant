<?php
namespace Command\Apc;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

abstract class Apc extends Command
{
    public static $files;

    protected $_ini_files = array('apc.ini', 'apcu.ini', 'opcache.ini', 'zzz_apc.ini', 'zzz_apcu.ini');

    public function __construct($name = null)
    {
        parent::__construct($name);

        if (!self::$files) {
            self::$files = __DIR__.'/../../util';
        }
    }
}