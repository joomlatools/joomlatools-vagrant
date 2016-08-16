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

<table class="table table-striped table-dashboard">
  <thead>
    <tr>
      <th>Site</th>
      <th>Action</th>
    </tr>
  </thead>
  <tbody>
  <?php foreach ($sites as $site) : ?>
    <tr>
      <td>
        <a target="_blank" href="<?php echo '/'.rtrim($site->docroot, "/").'/'; ?>">
          <?php echo $site->name ?></a>
        <small>(<?php echo $site->type ?> <?php echo $site->version; ?>)</small>
      </td>
      <td>
        <a class="btn btn-primary" href="/<?php echo rtrim($site->docroot, "/") . '/administrator/'; ?>" target="_blank">Administrator</a>
      </td>
    </tr>
  <?php endforeach; ?>
  </tbody>
</table>