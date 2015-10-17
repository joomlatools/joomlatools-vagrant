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

        if (\Helper\System::getEngine() === $engine)
        {
            $output->writeln(sprintf("<comment>[warning]</comment> Engine is already set to <info>%s</info>!", $engine));

            return;
        }

        switch ($engine)
        {
            case 'hhvm':
                `sudo a2enconf hhvm`;
                `sudo a2dismod php5 php7`;
                break;
            case 'zend':
                `sudo a2disconf hhvm`;

                if (version_compare(\Helper\System::getPHPVersion(), '7.0.0RC1', '<')) {
                    $php = 'php5';
                }
                else $php = 'php7';

                `sudo a2enmod $php`;
                break;
        }

        `sudo service apache2 restart`;

        $output->writeln('Switched engine to <info>' . $engine  . '</info>');
    }
}