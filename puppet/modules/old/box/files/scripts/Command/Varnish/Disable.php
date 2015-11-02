<?php
namespace Command\Varnish;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Output\OutputInterface;

class Disable extends Command
{
    protected function configure()
    {
        $this->setName('varnish:disable')
             ->setDescription('Disable Varnish cache');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        if (file_exists('/var/www/varnish-enabled'))
        {
            `sudo rm -f /var/www/varnish-enabled`;

            $this->getApplication()->find('varnish:clear')->run(new ArrayInput(array('command' => 'varnish:clear')), $output);

            $output->writeln('Varnish has been disabled');
        }
        else  $output->writeln('Varnish is already disabled!');
    }
}