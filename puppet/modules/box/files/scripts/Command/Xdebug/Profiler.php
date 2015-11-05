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

        $inis = \Helper\Ini::findIniFiles(array('zray-php5.5.ini', 'zray-php5.6.ini'), false);
        $ini  = array_pop($inis);
        if ($action == 'start' && file_exists($ini))
        {
            $contents = file_get_contents($ini);
            if (preg_match('/^zend_extension\\s*=\\s*.+zray\\.so/', $contents))
            {
                $output->writeln('[warning] <info>Zend Z-Ray</info> is enabled. This will generate a lot of profiler output!');
                $output->writeln('[warning] You can disable <info>Zend Z-Ray</info> with this command: <comment>box zray:disable</comment>');
            }
        }

        $current = \Helper\Ini::getPHPConfig('xdebug.profiler_enable');
        $value   = $action == 'start' ? 1 : 0;
        $word    = $action == 'start' ? 'started' : 'stopped';

        if ($current == $value)
        {
            $output->writeln("Profiler has already been $word");
            exit();
        }

        $files = \Helper\Ini::findIniFiles(array('custom.ini', '99-custom.ini'), false);

        foreach($files as $file) {
            \Helper\Ini::update($file, 'xdebug.profiler_enable', $value);
        }

        $this->getApplication()->find('server:restart')->run(new ArrayInput(array('command' => 'server:restart')), $output);

        $output_dir  = \Helper\Ini::getPHPConfig('xdebug.profiler_output_dir');

        $output->writeln("XDebug profiler has been $word");

        if ($action == 'start') {
            $output->writeln("Profiling information will be written to <info>$output_dir</info>");
        }
    }
}