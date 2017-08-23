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
            ->setDescription('Show current PHP engine or switch to another engine.')
            ->setHelp(<<<EOF
You can execute PHP code using either the Zend or HHVM engine. To show the current engine, run:

    <info>box php:engine</info>

To switch to HHVM, run

    <info>box php:engine hhvm</info>

To switch back to the default Zend engine:

    <info>box php:engine zend</info>
EOF
            )
            ->addArgument(
               'engine',
               InputArgument::OPTIONAL,
               'Desired PHP engine to use for virtual hosts. Omit to get current engine. Supported values: zend|hhvm'
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $currentEngine = \Helper\System::getEngine();
        $engine        = strtolower($input->getArgument('engine'));

        if (empty($engine))
        {
            $output->writeln(sprintf("Current engine is <info>%s</info>!", $currentEngine));

            return;
        }

        if (!in_array($engine, array('zend', 'hhvm'))) {
            throw new \RuntimeException('Unknown engine "' . $engine. '"');
        }

        if ($currentEngine === $engine)
        {
            $output->writeln(sprintf("<comment>[warning]</comment> Engine is already set to <info>%s</info>!", $engine));

            return;
        }

        switch ($engine)
        {
            case 'hhvm':
                `sudo a2enconf hhvm`;
                `sudo a2dismod php5`;

                if (file_exists('/etc/apache2/mods-available/php7.conf')) {
                    `sudo a2dismod php7`;
                }
                break;
            case 'zend':
                `sudo a2disconf hhvm`;

                if (version_compare(\Helper\System::getZendPHPVersion(), '7.0.0alpha1', '<')) {
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