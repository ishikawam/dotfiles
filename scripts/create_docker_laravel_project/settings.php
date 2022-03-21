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
exec('sed -i -e "s/\'DB_CONNECTION\', \'.*\'/\'DB_CONNECTION\', \'' . getenv('DATABASE_NAME') . '\'/g" config/database.php');

// config/session.php
exec('sed -i -e "s/\'SESSION_DRIVER\', \'.*\'/\'SESSION_DRIVER\', \'' . (getenv('MEMCACHED') ? 'memcached' : 'apc') . '\'/g" config/session.php');

// config/cache.php
exec('sed -i -e "s/\'CACHE_DRIVER\', \'.*\'/\'CACHE_DRIVER\', \'' . (getenv('MEMCACHED') ? 'memcached' : 'file') . '\'/g" config/cache.php');

// config/queue.php
exec('sed -i -e "s/mysql/' . getenv('DATABASE_NAME') . '/g" config/queue.php');

// .env
// APP_KEYのみにする
$str = file_get_contents('.env');
$str = preg_match('/^APP_KEY=.*$/m', $str, $out) ? $out[0] : '';
if ($str) {
    file_put_contents('.env', $str);
}

echo "\n[finish Settings (config, .env).]\n";

// docker-compose.yml
if (getenv('MEMCACHED')) {
    exec('sed -i -e "s/CACHE_DRIVER=.*/CACHE_DRIVER=memcached  # .envを上書きするため/g" docker-compose.yml');
}
