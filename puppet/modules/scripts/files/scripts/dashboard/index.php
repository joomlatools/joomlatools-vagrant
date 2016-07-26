<?php
define('_JEXEC', true);
define('JPATH_BASE', true);
define('JPATH_PLATFORM', true);

$dir = new DirectoryIterator('/var/www');
$i   = 1;
$sites = array();

$canonical = function($version) {
    if (isset($version->RELEASE)) {
        return 'v' . $version->RELEASE . '.' . $version->DEV_LEVEL;
    }

    // Joomla 3.5 and up uses constants instead of properties in JVersion
    $className = get_class($version);
    if (defined("$className::RELEASE")) {
        return 'v'. $version::RELEASE . '.' . $version::DEV_LEVEL;
    }

    return 'unknown';
};

foreach ($dir as $fileinfo)
{
    $code = $application = null;

    if ($fileinfo->isDir() && !$fileinfo->isDot())
    {
        $files = array(
            'joomla-cms'           => $fileinfo->getPathname() . '/libraries/cms/version/version.php',
            'joomlatools-platform' => $fileinfo->getPathname() . '/lib/libraries/cms/version/version.php',
            'joomla-1.5'           => $fileinfo->getPathname() . '/libraries/joomla/version.php'
        );

        foreach ($files as $type => $file)
        {
            if (file_exists($file))
            {
                $code        = $file;
                $application = $type;

                break;
            }
        }

        if (!is_null($code) && file_exists($code))
        {
            $identifier = uniqid();

            $source = file_get_contents($code);
            $source = preg_replace('/<\?php/', '', $source, 1);
            $source = preg_replace('/class JVersion/i', 'class JVersion' . $identifier, $source);

            eval($source);

            $class   = 'JVersion'.$identifier;
            $version = new $class();

            $sites[] = (object) array(
                'name'    => $fileinfo->getFilename(),
                'docroot' => $fileinfo->getFilename() . '/' . ($application == 'joomlatools-platform' ? 'web' : ''),
                'type'    => $application,
                'version' => $canonical($version)
            );
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="assets/images/favicon.ico">

    <title>Joomlatools Vagrant | Dashboard</title>

    <!-- Bootstrap CSS -->
    <link href="assets/css/bootstrap.css" rel="stylesheet">

    <!-- Custom styles for the dashboard -->
    <link href="assets/css/dashboard.css" rel="stylesheet">
  </head>

  <body>

    <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#"><img class="logo" src="assets/images/logo.svg" alt="">Joomlatools Vagrant</a>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="https://github.com/joomlatools/joomlatools-vagrant">Contribute on GitHub</a></li>
            <li><a href="http://developer.joomlatools.com/tools/vagrant/introduction.html" target="_blank">Docs</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li class="active"><a href="#">Dashboard</a></li>
          </ul>
          <ul class="nav nav-sidebar">
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
          </ul>
          <ul class="nav nav-sidebar">
            <li role="presentation" class="dropdown-header">System</li>
              <li><a href="/phpinfo">phpinfo</a></li>
              <li><a href="/pimpmylog">Log Files</a></li>
              <li><a href="/filebrowser">File Browser</a></li>
              <li><a href="/terminal">Terminal</a></li>
          </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <div class="table-responsive">
            <table class="table table-striped table-dashboard">
              <thead>
                <tr>
                  <th width="10">#</th>
                  <th>Sites Running On This Box</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
              <?php
              $i = 1;
              foreach ($sites as $site): ?>
                <tr>
                  <td><?php echo $i; ?></td>
                  <td>
                    <a target="_blank" href="/<?php echo rtrim($site->docroot, "/") . '/administrator/'; ?>">
                      <?php echo $site->name ?></a>
                    <small>(<?php echo $site->type ?> <?php echo $site->version; ?>)</small>
                  </td> 
                  <td>

                    <div class="btn-group">
                      <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#">Options <span class="caret"></span></a>
                      <ul class="dropdown-menu" role="menu">
                          <li><a href="/<?php echo $site->docroot; ?>" target="_blank">Site</a></li>
                          <li><a href="/<?php echo rtrim($site->docroot, "/") . '/administrator/'; ?>" target="_blank">Administrator</a></li>
                      </ul>
                    </div>
                  </td>
                </tr>
              <?php
                $i++;
                endforeach;
              ?>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="assets/js/bootstrap.js"></script>
  </body>
</html>
