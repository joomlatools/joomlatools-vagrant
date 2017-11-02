<?php
$cfg['AllowThirdPartyFraming']   = true;

$i = 1;

$cfg['Servers'][$i]['user']        = 'root';
$cfg['Servers'][$i]['password']    = '<%= @mysql_root_password %>';
$cfg['Servers'][$i]['auth_type']   = 'config';
$cfg['Servers'][$i]['controluser'] = 'phpmyadmin';
$cfg['Servers'][$i]['controlpass'] = 'phpmyadmin';
$cfg['Servers'][$i]['extension']   = 'mysqli';
$cfg['Servers'][$i]['DisableIS']   = true;
