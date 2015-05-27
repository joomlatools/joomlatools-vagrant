<?php
if (extension_loaded('apcu')) {
    require_once __DIR__.'/apcu.php';
} else {
    require_once __DIR__.'/apc.php';
}