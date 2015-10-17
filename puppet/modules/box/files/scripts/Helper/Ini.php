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
}