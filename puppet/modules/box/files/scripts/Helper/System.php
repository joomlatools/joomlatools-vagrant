<?php
namespace Helper;

class System
{
    public static function getZendPHPVersion()
    {
        $version = `/usr/bin/php -r 'echo phpversion();'`;
        $version = trim($version);

        return $version;
    }

    public static function getPHPCommand()
    {
        $bin = self::getEngine() == 'hhvm' ? '/usr/bin/hhvm --php' : '/usr/bin/php';

        return $bin;
    }

    public static function getEngine()
    {
        exec('a2query -q -c hhvm', $output, $exitCode);
        $hhvm = $exitCode === 0;

        return $hhvm ? 'hhvm' : 'zend';
    }
}