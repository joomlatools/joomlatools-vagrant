<?php
namespace Command\Php;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Engine extends Command
{
    protected function configure()
    {
        $this->setName('php:engine')
             ->setDescription('Switch PHP engine')
            ->addArgument(
                'engine',
                InputArgument::REQUIRED,
                'Desired PHP engine to use for virtual hosts. Supported values: zend|hhvm'
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $engine = strtolower($input->getArgument('engine'));

        if (!in_array($engine, array('zend', 'hhvm'))) {
            throw new \RuntimeException('Unknown engine "' . $engine. '"');
        }

        switch ($engine)
        {
            case 'hhvm':
                `sudo a2enconf hhvm`;
                `sudo a2dismod php5 php7`;
                break;
            case 'zend':
                `sudo a2disconf hhvm`;

                $version = `php -r 'echo phpversion();'`;
                $version = trim($version);

                if (version_compare($version, '7.0.0RC1', '<')) {
                    $php = 'php5';
                }
                else $php = 'php7';

                `sudo a2enmod $php`;
                break;
        }

        `sudo service apache2 restart`;

        $output->writeln('Switched to ' . $engine  . ' engine');
    }
}