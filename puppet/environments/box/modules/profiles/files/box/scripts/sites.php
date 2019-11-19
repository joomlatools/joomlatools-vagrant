<?php
$sites = [];

foreach (['joomla', 'folioshell'] as $command)
{
    $result   = `/home/vagrant/.composer/vendor/bin/$command site:list --format=json`;
    $response = json_decode($result);

    if (!is_null($response) && is_array($response->data)) {
        $sites = array_merge($sites, $response->data);
    }
}

usort($sites, function($a, $b) {
   return strcmp($a->name, $b->name);
});

$docroot = function($site) {
  $path = $site->name;

  if ($site->type == 'joomlatools-platform') {
    $path .= '/web/';
  }

  return $path;
};
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <title>Sites</title>

  <link href="assets/css/dashboard.css" rel="stylesheet">
</head>

<body style="overflow: scroll">
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
          <a target="_blank" href="<?php echo '/'.rtrim($docroot($site), "/").'/'; ?>">
            <?php echo $site->name ?></a>
          <small>(<?php echo $site->type ?> <?php echo $site->version; ?>)</small>
        </td>
        <td>
          <a class="btn btn-primary" href="/<?php echo rtrim($docroot($site), "/") . '/administrator/'; ?>" target="_blank">Administrator</a>
        </td>
      </tr>
    <?php endforeach; ?>
    </tbody>
  </table>
</body>
</html>