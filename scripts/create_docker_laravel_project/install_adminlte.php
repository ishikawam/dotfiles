<?php

/**
 * Install AdminLTE
 */

// index.blade.php
exec(sprintf('php %s/convert_html_to_blade.php %s %s', __DIR__, 'node_modules/admin-lte/index.html', 'resources/views/index.blade.php'));

// routes
exec('sed -i -e "s/welcome/index/g" routes/web.php');

// public
exec('ln -s ../node_modules/admin-lte/ public/');

// config/app.php
$str = file_get_contents('config/app.php');

$text = '
        Laravel\Socialite\SocialiteServiceProvider::class,
';
$str = preg_replace('/(\bproviders\b.*?)(    ],)/s', "\\1$text\n\\2", $str);

$text = '
        \'Socialite\' => Laravel\Socialite\Facades\Socialite::class,
';
$str = preg_replace('/(\baliases\b.*?)(    ],)/s', "\\1$text\n\\2", $str);

file_put_contents('config/app.php', $str);

// config/services.php
$str = file_get_contents('config/services.php');
$text = sprintf("
    'facebook' => [
        'client_id' => 'app id',
        'client_secret' => 'add secret',
        'redirect' => 'http://localhost:%s/auth/facebook/callback',
    ],
", getenv('HTTP_PORT'));
$str = preg_replace('/(];)/', "$text\\1", $str);
file_put_contents('config/services.php', $str);
