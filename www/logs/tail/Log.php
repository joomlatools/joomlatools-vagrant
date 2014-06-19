<?php
require 'PHPTail.php';

$logs = glob('/var/log/apache2/*');
$logs[] = '/var/log/mysql/error.log';


$tail = new PHPTail($logs);

if(isset($_GET['ajax']))  {
	echo $tail->getNewLines($_GET['lastsize'], $_GET['grep'], $_GET['invert']);
	die();
}


$tail->generateGUI();