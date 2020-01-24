<?php
$navigation = array();

$navigation['dashboard']['title'] = 'Sites';
$navigation['dashboard']['source'] = '/sites.php';
$navigation['dashboard']['type'] = 'iframe';
$navigation['dashboard']['status'] = 'active';

$navigation['system']['title'] = 'System';
$navigation['system']['type'] = 'separator';

$navigation['phpinfo']['title'] = 'PHP Info';
$navigation['phpinfo']['source'] = '/phpinfo';
$navigation['phpinfo']['type'] = 'iframe';
$navigation['phpinfo']['status'] = 'active';

$navigation['terminal']['title'] = 'Terminal';
$navigation['terminal']['source'] = '/terminal';
$navigation['terminal']['type'] = 'iframe';
$navigation['terminal']['status'] = 'active';

$navigation['filebrowser']['title'] = 'Files';
$navigation['filebrowser']['source'] = '/filebrowser';
$navigation['filebrowser']['type'] = 'iframe';
$navigation['filebrowser']['status'] = 'active';

$navigation['pimpmylog']['title'] = 'Logs';
$navigation['pimpmylog']['source'] = '/pimpmylog';
$navigation['pimpmylog']['type'] = 'page';
$navigation['pimpmylog']['status'] = 'active';

$navigation['tools']['title'] = 'Tools';
$navigation['tools']['type'] = 'separator';

$navigation['phpmyadmin']['title'] = 'phpMyAdmin';
$navigation['phpmyadmin']['source'] = 'http://phpmyadmin.joomla.box';
$navigation['phpmyadmin']['type'] = 'iframe';
$navigation['phpmyadmin']['status'] = 'active';

$navigation['mailhog']['title'] = 'Mailhog';
$navigation['mailhog']['source'] = 'http://joomla.box:8025';
$navigation['mailhog']['type'] = 'iframe';
$navigation['mailhog']['status'] = 'active';

$navigation['apc-dashboard']['title'] = 'APC Dashboard';
$navigation['apc-dashboard']['source'] = '/apc';
$navigation['apc-dashboard']['type'] = 'iframe';
$navigation['apc-dashboard']['status'] = (extension_loaded('apc') || extension_loaded('apcu')) && ini_get('apc.enabled') ? 'active' : 'disabled';

$navigation['webgrind']['title'] = 'Webgrind';
$navigation['webgrind']['source'] = 'http://webgrind.joomla.box';
$navigation['webgrind']['type'] = 'iframe';
$navigation['webgrind']['status'] = extension_loaded('xdebug') ? 'active' : 'disabled';

$navigation['cockpit']['title'] = 'Cockpit';
$navigation['cockpit']['source'] = 'http://joomla.box/cockpit';
$navigation['cockpit']['type'] = 'page';
$navigation['cockpit']['status'] = 'active';
