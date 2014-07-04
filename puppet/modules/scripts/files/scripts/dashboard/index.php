<html>
	<body>
		<h1>It works!</h1>
		<p>This is the default web page for this server.</p>
		<h2>Installed sites:</h2>
		<?php
        define('_JEXEC', true);
        define('JPATH_PLATFORM', true);

		$dir = new DirectoryIterator('/var/www');
		foreach ($dir as $fileinfo)
		{
			if ($fileinfo->isDir() && !$fileinfo->isDot())
			{
                $code = $fileinfo->getPathname() . '/libraries/cms/version/version.php';

                if (file_exists($code))
				{
                    $identifier = uniqid();

                    $source = file_get_contents($code);
                    $source = preg_replace('/<\?php/', '', $source, 1);
                    $source = preg_replace('/class JVersion/i', 'class JVersion' . $identifier, $source);

                    eval($source);

                    $class   = 'JVersion'.$identifier;
                    $version = new $class();
					?>
					<a href="/<?php echo $fileinfo->getFilename() ?>">
						<?php echo $fileinfo->getFilename() ?>
					</a> (<a href="<?php echo $fileinfo->getFilename() . '/administrator/'; ?>">administrator</a>) - version <?php echo $version->RELEASE.'.'.$version->DEV_LEVEL; ?>
					<br>
				<?php
				}
			}
		}
		?>
		<p>To install new sites, check out the documentation at <a href="https://github.com/joomlatools/joomla-console#create-sites">the joomla-console repository</a>.</p>
		<h2>Tools:</h2>
        <ul>
            <li><a href="/phpinfo">phpinfo()</a></li>
            <?php if (function_exists('apc_cache_info') && @apc_cache_info('opcode')): ?>
                <li><a href="/apc">APC dashboard</a></li>
            <?php endif; ?>
		    <li><a href="http://phpmyadmin.joomla.dev/">PHPmyAdmin</a></li>
            <li><a href="/logs/tail/Log.php">Log files</a></li>
        </ul>
	</body>
</html>