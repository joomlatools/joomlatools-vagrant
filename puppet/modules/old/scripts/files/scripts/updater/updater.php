#!/usr/bin/php5
<?php
if (file_exists('/home/vagrant/scripts/updater/UPDATE_AVAILABLE')) {
    exit;
}

exec("composer show --all joomlatools/joomla-console 2>&1", $result, $code);

if ($code === 1) {
    exit(1); // Failed to fetch info from packagist
}

$versions = array();
foreach ($result as $line => $content)
{
    $content = trim($content);

    if (strpos($content, 'versions') === 0)
    {
        $parts = explode(':', $content);

        if (count($parts) > 1)
        {
            $versions = explode(', ', $parts[1]);
            break;
        }
    }
}

$versions = array_map('trim', $versions);
array_filter($versions);

if (!count($versions)) {
    exit(1); // No available versions found!
}

$manifest = json_decode(file_get_contents('/home/vagrant/.composer/composer.lock'));
if (!$manifest) {
    exit(1); // No composer.lock file?
}

$currentVersion = false;
foreach ($manifest->packages as $package)
{
    if ($package->name == 'joomlatools/console')
    {
        if (substr($package->version, 0, 1) != 'v') {
            return; // Only update stable releases
        }

        $currentVersion = substr($package->version, 1);

        break;
    }
}

if (!$currentVersion) {
    exit(1); // Could not find current version
}

$latest = '0.1';
foreach ($versions as $version)
{
    if (preg_match('/^v[0-9]+\.[0-9]+\.[0-9]+$/', $version))
    {
        $version = substr($version, 1);

        if (version_compare($version, $currentVersion, '>') && version_compare($version, $latest, '>')) {
            $latest = $version;
        }
    }
}

if ($latest != '0.1') {
    file_put_contents('/home/vagrant/scripts/updater/UPDATE_AVAILABLE', $latest);
}
