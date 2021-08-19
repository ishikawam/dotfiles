<?php

/**
 * Settings (config, .env)
 *
 * PROJECT_NAME
 * DATABASE_NAME
 */

echo "\n[start Settings (config, .env).]\n";

// config/app.php
$str = file_get_contents('config/app.php');
$str = preg_replace('/\'en\'/', '\'ja\'', $str);
$str = preg_replace('/\'en_US\'/', '\'ja_JP\'', $str);
$str = preg_replace('/\'UTC\'/', '\'Asia/Tokyo\'', $str);
$str = preg_replace('/(\'APP_NAME\', )(\'.*?\')/', '\\1\'' . getenv('PROJECT_NAME') . '\'', $str);
file_put_contents('config/app.php', $str);

// config/database.php
exec('gsed -i -e "s/\'DB_CONNECTION\', \'mysql\'/\'DB_CONNECTION\', \'' . getenv('DATABASE_NAME') . '\'/g" config/database.php');

// config/queue.php
exec('gsed -i -e "s/mysql/' . getenv('DATABASE_NAME') . '/g" config/queue.php');

// .env
// APP_KEYのみにする
$str = file_get_contents('.env');
$str = preg_match('/^APP_KEY=.*$/m', $str, $out) ? $out[0] : '';
if ($str) {
    file_put_contents('.env', $str);
}

echo "\n[finish Settings (config, .env).]\n";
