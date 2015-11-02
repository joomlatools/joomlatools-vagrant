<?php
if (extension_loaded('apcu') || defined('HHVM_VERSION')) {
    require_once __DIR__ . '/apcu.php';
} else {
    require_once __DIR__ . '/apc.php';
}