<div class="sidebar">
    <ul class="nav nav-sidebar">
        <li<?php echo strpos($_SERVER['PHP_SELF'], '/dashboard/') ? ' class="active"' : '' ?>><a href="../dashboard/">Dashboard</a></li>
        <li role="presentation" class="dropdown-header">Tools</li>
        <li><a href="http://phpmyadmin.joomla.box/">phpMyAdmin</a></li>
        <li><a href="/mailcatcher">MailCatcher</a></li>
        <?php if (function_exists('apc_cache_info') && @apc_cache_info('opcode')): ?>
            <li><a href="/apc">APC dashboard</a></li>
        <?php endif; ?>
        <?php if (function_exists('zray_disable')): ?>
            <li><a href="http://joomla.box:8080/ZendServer">Z-Ray</a></li>
        <?php endif; ?>
        <?php if (extension_loaded('xdebug')): ?>
            <li><a href="http://webgrind.joomla.box">Webgrind</a></li>
        <?php endif; ?>
        <li role="presentation" class="dropdown-header">System</li>
        <li><a href="/phpinfo">phpinfo</a></li>
        <li><a href="/pimpmylog">Log Files</a></li>
        <li><a href="/filebrowser">File Browser</a></li>
        <li<?php echo strpos($_SERVER['PHP_SELF'], '/terminal/') ? ' class="active"' : '' ?>><a href="../terminal/">Terminal</a></li>
    </ul>
</div>
