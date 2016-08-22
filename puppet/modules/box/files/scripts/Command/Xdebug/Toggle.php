<?php
namespace Command\Xdebug;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Output\NullOutput;

class Toggle extends Xdebug
{
    protected function configure()
    {
        $this->setName('xdebug:toggle')
             ->setDescription('Toggle Xdebug');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        parent::execute($input, $output);

        if (extension_loaded('xdebug'))
        {
            $this->getApplication()->find('xdebug:disable')->run($input, $output);
        } else {
            $this->getApplication()->find('xdebug:enable')->run($input, $output);
        }
    }
}