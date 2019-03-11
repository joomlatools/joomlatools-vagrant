<?php
namespace Command\Xdebug;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

abstract class Xdebug extends Command
{
    protected $_ini_files = array('xdebug.ini');
}