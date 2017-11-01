<?php
namespace Helper;

class Ini
{
    /**
     * Write a key=value pair to the given ini file.
     * If the key already exists, its value will be
     * overwritten.
     *
     * @param $file Full path to the .ini file
     * @param $key  Key value
     * @param $value New value
     */
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

    /**
     * Loop over all installed PHP versions and find
     * the given base names. Will return a list of
     * absolute paths to the ini files.
     *
     * @param array $basenames array Array of ini file names to look for.
     * @param boolean $global If set to the false, the method will only look for the given ini in the currently enabled PHP version
     * @return array  List of absolute paths
     */
    public static function findIniFiles($basenames = array(), $global = true)
    {
        $inis  = array();

        if ($global === false)
        {
            $version = \Helper\System::getZendPHPVersion();

            if (file_exists("/opt/php/php-$version/etc/conf.d")) {
                $paths = array("/opt/php/php-$version/etc/conf.d");
            }
            else $paths = array('/etc/php/7.1/mods-available/');
        }
        else
        {
            $paths = array('/etc/php/7.1/mods-available/');

            $installs = glob('/opt/php/php-*/etc/conf.d', GLOB_ONLYDIR);
            $installs = array_unique(array_filter($installs));

            $paths = array_merge($paths, $installs);
        }

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

    /**
     * Look up the value for the given ini directive
     * in the currently active PHP version.
     *
     * @param $key
     * @return bool
     */
    public static function getPHPConfig($key)
    {
        $bin     = \Helper\System::getPHPCommand();

        // Special case: since we explicitly disable xdebug.profiler_enable_trigger on CLI commands
        // we need to omit this when looking up this specific key.
        // Otherwise the result will always be 0
        if ($key == 'xdebug.profiler_enable_trigger') {
            $bin = str_replace('-d xdebug.profiler_enable_trigger=0', '', $bin);
        }

        $current = `$bin -r "\\\$value = ini_get('$key'); echo \\\$value === false ? 'unknown-directive' : \\\$value;"`;

        if ($current == 'unknown-directive') {
            return false;
        }

        return $current;
    }
}