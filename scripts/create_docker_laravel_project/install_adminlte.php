<?php

/**
 * Install AdminLTE
 *
 * @todo; Laravelの設定、に変更したい。対話式で。
 */

echo "\n[start Install AdmiLTE]\n";

// index.blade.php
system(sprintf('php %s/convert_html_to_blade.php %s %s', __DIR__, 'node_modules/admin-lte/index.html', 'resources/views/index.blade.php'));

// v2よりv1のほうがいいかも
// cp resources/views/auth/login.blade.php resources/views/auth/login_.blade.php
// php ~/scripts/create_docker_laravel_project/convert_html_to_blade.php node_modules/admin-lte/pages/examples/login.html resources/views/auth/login.blade.php
// cp resources/views/auth/forgot-password.blade.php resources/views/auth/forgot-password_.blade.php
// php ~/scripts/create_docker_laravel_project/convert_html_to_blade.php node_modules/admin-lte/pages/examples/forgot-password.html resources/views/auth/forgot-password.blade.php
// cp resources/views/auth/register.blade.php resources/views/auth/register_.blade.php
// php ~/scripts/create_docker_laravel_project/convert_html_to_blade.php node_modules/admin-lte/pages/examples/register.html resources/views/auth/register.blade.php
// やっぱloginだけで、、Facebookしか使わないので

// routes
system('sed -i -e "s/welcome/index/g" routes/web.php');

// public
system('ln -s ../node_modules/admin-lte/ public/');

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

# AdminLTEじゃなくても @todo;
$str = preg_replace('/\'en\'/', '\'ja\'', $str);
$str = preg_replace('/\'en_US\'/', '\'ja_JP\'', $str);
$str = preg_replace('/\'UTC\'/', '\'Asia/Tokyo\'', $str);
$str = preg_replace('/(\'APP_NAME\', )(\'.*?\')/', '\\1\'' . getenv('PROJECT_NAME') . '\'', $str);

file_put_contents('config/app.php', $str);


// これはAdminLTEじゃなくてもならないと @todo;
// .env
$str = file_get_contents('.env');
$str = preg_match('/^APP_KEY=.*$/', $str, $out) ? $out[0] : '';
if ($str) {
    file_put_contents('.env', $str);
}


// これはSocialiteでやること
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

echo "\n[finish Install AdmiLTE]\n";
