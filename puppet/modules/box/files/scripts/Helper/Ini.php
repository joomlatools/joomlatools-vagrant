<?php
namespace Helper;

class Ini
{
    public static function update($file, $key, $value)
    {
        $values = parse_ini_file($file);
        $values[$key] = $value;

        $string = '';
        foreach($values as $k => $v)
        {
            if (!empty($v) || $v === '0') {
                $string .= "$k = $v" . PHP_EOL;
            }
        }

        if (!is_writable($file)) {
            `sudo chmod o+rw $file`;
        }

        file_put_contents($file, $string);
    }

    public static function findIniFiles($basenames = array())
    {
        $inis  = array();
        $paths = array('/etc/php5/mods-available/');

        $installs = glob('/opt/php/php-*/etc/conf.d', GLOB_ONLYDIR);
        $installs = array_unique(array_filter($installs));

        $paths = array_merge($paths, $installs);

        foreach($paths as $path)
        {
            foreach($basenames as $basename)
            {
                $fullpath = $path . '/' . $basename;
                if(file_exists($fullpath)) {
                    $inis[] = $fullpath;
                }
            }
        }

        return $inis;
    }
}