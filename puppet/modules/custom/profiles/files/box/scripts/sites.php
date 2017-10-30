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