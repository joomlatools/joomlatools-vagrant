<?php
namespace Command\Varnish;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Output\OutputInterface;

class Clear extends Command
{
    protected function configure()
    {
        $this->setName('varnish:clear')
             ->setDescription('Clear the cache');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        `sudo varnishadm -T 127.0.0.1:6082 -S /etc/varnish/secret "ban req.url ~ ."`;

        $output->writeln('Cleared the Varnish cache');
    }
}