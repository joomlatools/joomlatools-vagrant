<?php
$result   = `/home/vagrant/.composer/vendor/bin/joomla site:list --format=json`;
$response = json_decode($result);

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

<body>
  <table class="table table-striped table-dashboard">
    <thead>
      <tr>
        <th>Site</th>
        <th>Action</th>
      </tr>
    </thead>
    <tbody>
    <?php if (is_array($response->data)): ?>
    <?php foreach ($response->data as $site) : ?>
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
    <?php endif; ?>
    </tbody>
  </table>
</body>
</html>