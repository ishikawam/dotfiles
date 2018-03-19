#!/usr/bin/php
<?php
// for php5.5 over.
/**
 * exifの撮影日時をファイル名、作成日時、更新日時にする
 * 拡張子jpe?gに絞る。
 * ファイル、フォルダを指定できるが、recursiveではない。
 */

date_default_timezone_set('Asia/Tokyo');

array_shift($argv);
if (empty($argv)) {
    $argv = ['.'];
}
$paths = [];
foreach ($argv as $arg) {
    if (is_dir($arg)) {
        $paths = array_merge(glob("$arg/*")); // ディレクトリは第1階層のみ
    }
    if (is_file($arg)) {
        $paths[] = $arg;
    }
}

// jpg, jpegに絞り込む
$paths = array_filter($paths, function ($c) {
    return preg_match('/\.jpe?g$/i', $c);
});

if (empty($paths)) {
    echo "\nexit.\n";
}

foreach ($paths as $path) {
    $exif = @exif_read_data($path);
    $datetime = isset($exif['DateTimeOriginal']) ? $exif['DateTimeOriginal'] : '';
    if ($datetime) {
        // 既に日付があったら消して書き直す
        $newfilename = preg_replace('|/([0-9]{6,8}_)?([^/]*)$|', '/' . date('Ymd', strtotime($datetime)) . '_$2', $path);
        echo "$path -> \033[0;32m$newfilename\033[0m\n";
    } else {
        echo "$path -> \033[1;33mnothing.\033[0m\n";
    }
}

echo "\nok?\n";
$line = trim(fgets(STDIN));

if (!empty($line)) {
    echo "\nexit.\n";
    exit;
}

foreach ($paths as $path) {
    $exif = @exif_read_data($path);
    /**
     * DateTimeOriginal
     */
    $datetime = isset($exif['DateTimeOriginal']) ? $exif['DateTimeOriginal'] : '';
    if ($datetime) {
        // 既に日付があったら消して書き直す
        $newfilename = preg_replace('|/([0-9]{6,8}_)?([^/]*)$|', '/' . date('Ymd', strtotime($datetime)) . '_$2', $path);
        rename($path, $newfilename);
        touch($newfilename, strtotime($datetime));  // 更新日時も変更
    }
}

echo "\nDONE\n";

