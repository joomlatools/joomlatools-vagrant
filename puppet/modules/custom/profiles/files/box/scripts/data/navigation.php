<?php
$navigation = array();

$navigation['dashboard']['title'] = 'Sites';
$navigation['dashboard']['source'] = 'sites.php';
$navigation['dashboard']['type'] = 'include';
$navigation['dashboard']['status'] = 'active';

$navigation['system']['title'] = 'System';
$navigation['system']['type'] = 'separator';

$navigation['phpinfo']['title'] = 'PHP Info';
$navigation['phpinfo']['source'] = '/phpinfo';
$navigation['phpinfo']['type'] = 'iframe';
$navigation['phpinfo']['status'] = 'active';

$navigation['pimpmylog']['title'] = 'Logs';
$navigation['pimpmylog']['source'] = '/pimpmylog';
$navigation['pimpmylog']['type'] = 'iframe';
$navigation['pimpmylog']['status'] = 'active';

$navigation['filebrowser']['title'] = 'Files';
$navigation['filebrowser']['source'] = '/filebrowser';
$navigation['filebrowser']['type'] = 'iframe';
$navigation['filebrowser']['status'] = 'active';

$navigation['terminal']['title'] = 'Terminal';
$navigation['terminal']['source'] = '/terminal';
$navigation['terminal']['type'] = 'iframe';
$navigation['terminal']['status'] = 'active';

$navigation['tools']['title'] = 'Tools';
$navigation['tools']['type'] = 'separator';

$navigation['phpmyadmin']['title'] = 'phpMyAdmin';
$navigation['phpmyadmin']['source'] = 'http://phpmyadmin.joomla.box';
$navigation['phpmyadmin']['type'] = 'iframe';
$navigation['phpmyadmin']['status'] = 'active';

$navigation['mailcatcher']['title'] = 'MailCatcher';
$navigation['mailcatcher']['source'] = '/mailcatcher';
$navigation['mailcatcher']['type'] = 'page';
$navigation['mailcatcher']['status'] = 'active';

$navigation['apc-dashboard']['title'] = 'APC Dashboard';
$navigation['apc-dashboard']['source'] = '/apc';
$navigation['apc-dashboard']['type'] = 'iframe';
$navigation['apc-dashboard']['status'] = function_exists('apc_cache_info') && @apc_cache_info('opcode') ? 'active' : 'disabled';

$navigation['webgrind']['title'] = 'Webgrind';
$navigation['webgrind']['source'] = 'http://webgrind.joomla.box';
$navigation['webgrind']['type'] = 'iframe';
$navigation['webgrind']['status'] = extension_loaded('xdebug') ? 'active' : 'disabled';
