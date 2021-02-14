<?php

/**
 * Configure Socialite
 *
 * HTTP_PORT
 */

echo "\n[start Configure Socialite]\n";


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

echo "\n[finish Configure Socialite]\n";


// @todo;
/*
    # app/Providers/EventServiceProvider.phpの更新も @todo;
    #// Socialite
    #\SocialiteProviders\Manager\SocialiteWasCalled::class => [
    #// facebook
    #'SocialiteProviders\\Facebook\\FacebookExtendSocialite@handle',
    #],
    #// routes/web.php も
    #// Social Login
    #Route::prefix('login/{provider}')->where(['provider' => '(facebook)'])->group(function(){
    #Route::get('/', 'App\Http\Controllers\Auth\LoginController@redirectToProvider')->name('social_login.redirect');
    #Route::get('/callback', 'App\Http\Controllers\Auth\LoginController@handleProviderCallback')->name('social_login.callback');
    #});

    # https://blog.capilano-fw.com/?p=7862
*/
