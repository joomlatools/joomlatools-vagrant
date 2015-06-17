<?php
define('_JEXEC', true);
define('JPATH_PLATFORM', true);

$dir = new DirectoryIterator('/var/www');
$i   = 1;
$sites = array();
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
      $sites[$fileinfo->getFilename()] = (object) array('version' => $version->RELEASE.'.'.$version->DEV_LEVEL);
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

    <title>Joomla in a Box | Dashboard</title>

    <!-- Bootstrap CSS -->
    <link href="assets/css/bootstrap.css" rel="stylesheet">

    <!-- Custom styles for the dashboard -->
    <link href="assets/css/dashboard.css" rel="stylesheet">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="assets/javascripts/ie10-viewport-bug-workaround.js"></script>

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
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
          <a class="navbar-brand" href="#"><img class="logo" src="assets/images/joomla-in-a-box.svg" alt="Joomla in a Box">Joomla in a box</a>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="https://github.com/joomlatools/joomla-vagrant">Contribute on GitHub</a></li>
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
            <li><a href="http://joomla.box:1080/">MailCatcher</a></li>
            <?php if (function_exists('apc_cache_info') && @apc_cache_info('opcode')): ?>
                <li><a href="/apc">APC dashboard</a></li>
            <?php endif; ?>
          </ul>
          <ul class="nav nav-sidebar">
            <li role="presentation" class="dropdown-header">System</li>
              <li><a href="/phpinfo">phpinfo</a></li>
              <li><a href="/pimpmylog">Log Files</a></li>
              <li><a href="http://joomla.box:3000/">Terminal</a></li>
          </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        <p>To install new sites, check out the documentation on <a href="https://github.com/joomlatools/joomla-console#create-sites">Github</a>.</p>
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
              foreach ($sites as $site => $info): ?>
                <tr>
                  <td><?php echo $i; ?></td>
                  <td>
                    <a target="_blank" href="/<?php echo $site . '/administrator/'; ?>">
                      <?php echo $site ?></a>
                    <small>(v<?php echo $info->version; ?>)</small>
                  </td> 
                  <td>

                    <div class="btn-group">
                      <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#">Options <span class="caret"></span></a>
                      <ul class="dropdown-menu" role="menu">
                          <li><a href="/<?php echo $site; ?>" target="_blank">Site</a></li>
                          <li><a href="/<?php echo $site . '/administrator/'; ?>" target="_blank">Administrator</a></li>
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
    <script src="assets/javascripts/bootstrap.js"></script>
  </body>
</html>
