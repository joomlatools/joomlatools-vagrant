<?php
namespace Command\Varnish;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Output\OutputInterface;

class Enable extends Command
{
    protected function configure()
    {
        $this->setName('varnish:enable')
             ->setDescription('Enable Varnish cache');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        if (!file_exists('/var/www/varnish-enabled'))
        {
            `sudo touch /var/www/varnish-enabled`;

            $this->getApplication()->find('varnish:clear')->run(new ArrayInput(array('command' => 'varnish:clear')), $output);

            $output->writeln('Varnish has been enabled.');
            $output->writeln('You can edit the VCL file at <comment>/etc/varnish/default.vcl</comment>');
        }
        else $output->writeln('Varnish is already enabled!');
    }
}