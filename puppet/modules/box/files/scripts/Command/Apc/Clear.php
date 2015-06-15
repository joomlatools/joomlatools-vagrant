<?php
namespace Command\Apc;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Clear extends Apc
{
    protected function configure()
    {
        $this->setName('apc:clear')
             ->setDescription('Clear APC cache');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        copy(self::$files.'/apc_clear.php', '/var/www/apc_clear.php');

        $url = 'http://localhost/apc_clear.php';
        $result = json_decode(file_get_contents($url));

        unlink('/var/www/apc_clear.php');

        if($result->status != 'success') {
            echo 'Failed to clear APC cache!' . PHP_EOL;
        }
        else $output->writeln('Done');
    }
}