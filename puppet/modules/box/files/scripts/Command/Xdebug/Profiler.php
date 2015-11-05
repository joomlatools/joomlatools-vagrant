<?php
namespace Command\Xdebug;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Output\OutputInterface;

class Profiler extends Xdebug
{
    protected function configure()
    {
        $this->setName('xdebug:profiler')
             ->setDescription('Toggle profiling')
            ->addArgument(
                'action',
                InputArgument::REQUIRED,
                'start|stop'
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        parent::execute($input, $output);

        if (!extension_loaded('xdebug'))
        {
            $output->writeln('[error] XDebug is not loaded. You can enable it using the <comment>box xdebug:enable</comment> command.');
            exit();
        }

        $action = strtolower($input->getArgument('action'));

        if (!in_array($action, array('start', 'stop'))) {
            throw new \RuntimeException('Action must be one of start|stop');
        }

        $enabled = \Helper\Ini::getPHPConfig('xdebug.profiler_enable_trigger');
        $current = \Helper\Ini::getPHPConfig('xdebug.profiler_enable_trigger_value');
        $trigger = $action == 'start' ? 1 : 0;
        $value   = $action == 'start' ? 'joomlatools' : '';

        if ($action == 'start')
        {
            if ($current == 'joomlatools' && $enabled == 1)
            {
                $output->writeln("Profiler is already enabled.");
                exit();
            }
        }
        else
        {
            if (empty($current) && $enabled == 0)
            {
                $output->writeln("Profiler is not running.");
                exit();
            }
        }

        $files = \Helper\Ini::findIniFiles(array('custom.ini', '99-custom.ini'), false);

        foreach($files as $file)
        {
            \Helper\Ini::update($file, 'xdebug.profiler_enable_trigger', $trigger);
            \Helper\Ini::update($file, 'xdebug.profiler_enable_trigger_value', $value);
        }

        $this->getApplication()->find('server:restart')->run(new ArrayInput(array('command' => 'server:restart', 'service' => array('apache'))), $output);

        $verb = $action == 'start' ? 'started' : 'stopped';
        $output->writeln("XDebug profiler has been $verb");

        if ($action == 'start')
        {
            $output_dir = \Helper\Ini::getPHPConfig('xdebug.profiler_output_dir');
            $output->writeln("Profiling information will be written to <info>$output_dir</info>");
        }
    }
}