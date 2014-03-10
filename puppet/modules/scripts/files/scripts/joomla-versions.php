<?php

require_once 'Console/CommandLine.php';

class JoomlaVersions
{
    public static $directory;

    public $task;

    public function __construct($task)
    {
        if (!self::$directory) {
            self::$directory = __DIR__.'/joomla_files';
        }

        $this->task = $task;
    }

    public function run()
    {
        try {
            $task = $this->task;
            $this->$task();
        }
        catch (Exception $e) {
            $this->error($e->getMessage());
        }
    }

    public function show()
    {
        $list = $this->getVersions();

        foreach($list as $ref => $versions)
        {
            echo "\033[0;32m" . ($ref == 'heads' ? "Available branches:" : "Available releases") . "\033[0m" . PHP_EOL;

            $chunks = array_chunk($versions, 5);

            foreach($chunks as $chunk)
            {
                $format = str_repeat("%-25s", count($chunk)) . PHP_EOL;
                call_user_func_array('printf', array_merge(array($format), $chunk));
            }
        }
    }

    public function refresh()
    {
        $file = self::$directory.'/versions.cache';

        if(file_exists($file)) {
            unlink($file);
        }

        $result = `git ls-remote https://github.com/joomla/joomla-cms.git | grep -E 'refs/(tags|heads)' | grep -v '{}'`;
        $refs   = explode(PHP_EOL, $result);

        $versions = array();
        $pattern  = '/^[a-z0-9]+\s+refs\/(heads|tags)\/([a-z0-9\.\-_]+)$/im';
        foreach($refs as $ref)
        {
            if(preg_match($pattern, $ref, $matches))
            {
                $type = isset($versions[$matches[1]]) ? $versions[$matches[1]] : array();

                if($matches[1] == 'tags')
                {
                    if($matches[2] == '1.7.3' || !preg_match('/^\d\.\d+/m', $matches[2])) {
                        continue;
                    }
                }

                $type[] = $matches[2];
                $versions[$matches[1]] = $type;
            }
        }

        file_put_contents($file, json_encode($versions));

        if($this->task == 'refresh') {
            $this->show();
        }
    }

    public static function fromInput()
    {
        $parser = new Console_CommandLine();
        $parser->description = "Show available versions in Joomla Git repository";

        $parser->addArgument('task', array(
            'description' => 'show|refresh',
            'help_name'   => 'TASK'
        ));

        try
        {
            $result   = $parser->parse();
            $task     = $result->args['task'];

            $instance = new self($task);
            $instance->run();
        }
        catch (Exception $e) {
            $parser->displayError($e->getMessage());
        }
    }

    public function getVersions()
    {
        $file = self::$directory.'/versions.cache';

        if(!file_exists($file)) {
            $this->refresh();
        }

        $list = json_decode(file_get_contents($file), true);
        $list = array_reverse($list, true);

        return $list;
    }
}
