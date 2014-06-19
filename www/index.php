<html>
	<body>
		<h1>It works!</h1>
		<p>This is the default web page for this server.</p>
		<h2>Installed sites:</h2>
		<?php
		$dir = new DirectoryIterator('.');
		foreach ($dir as $fileinfo)
		{
			if ($fileinfo->isDir() && !$fileinfo->isDot())
			{
				$subfolders = scandir($fileinfo);

				// Checks if is a joomla site (avoids to show folders like /logs/ )
				if (in_array("administrator", $subfolders))
				{
					?>
					<a href="<?php echo $fileinfo->getFilename() ?>">
						<?php echo $fileinfo->getFilename() ?>
					</a> (<a href="<?php echo $fileinfo->getFilename() . '/administrator/'; ?>">administrator</a>)
					<br>
				<?php
				}
			}
		}
		?>
		<p>To install new sites check the instructions at <a href="https://github.com/joomlatools/joomla-console#create-sites">https://github.com/joomlatools/joomla-console#create-sites</a></p>
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