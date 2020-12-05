<?php

/**
 * Convert html to blade.
 * 
 * `php convert_html_to_blade.php file`
 * `php convert_html_to_blade.php from-file to-file`
 */

// ファイル名チェック
$file = $argv[1] ?? '';

$toFile = $argv[2] ?? $file;

if (! file_exists($file)) {
    echo "\nfile not exists.\n";
    exit;
}

if (! preg_match('/\.blade\.php$/', $file)) {
    echo "\nonly blade file.\n";
    exit;
}

$str = file_get_contents($file);

// サイトルート相対パスに置き換え
$str = preg_replace('/ (href|src)="(#.*?)"/', ' \\1_="\\2"', $str);
$str = preg_replace('/ (href|src)="(https?:\/\/.*?)"/', ' \\1_="\\2"', $str);
$str = preg_replace('/ (href|src)="(.*?)"/', ' \\1_="/admin-lte/\\2"', $str);
$str = preg_replace('/ (href|src)_=/', ' \\1=', $str);

// html lang
$str = preg_replace('/<html lang=".*?">/', '<html lang="{{ str_replace(\'_\', \'-\', app()->getLocale()) }}">', $str);

// save
file_put_contents($toFile, $str);

echo "\nconvert html to blade, done.\n\n";
