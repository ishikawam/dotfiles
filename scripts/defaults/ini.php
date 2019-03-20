<?php

/**
 * defaults.phpではできない、iniの管理
 * @todo;
 * 
evernoteの "NSOutlineView Items ENExpandedLeftNavItems.*" を
(
    recents,
    shortcuts,
    notes
);
にしたい。慎重に。
 */

echo "\n\n### ini.php ###\n\n";

$HOSTNAME = exec('hostname');
$HOME = exec('echo $HOME');

if (! file_exists($HOME . '/Library/')) {
    echo "No ~/Library/. Do nothing.\n\n";
    return;
}

if (preg_match('/^ishikawa-/', $HOSTNAME) || file_exists($HOME . '/this/.force-defaults')) {
    echo "run.\n\n";
} else {
    echo "not run.\n\n";
    return;
}

$arr = [
    // LINE
    // これだめ。初期ではそもそも項目がないからデフォルトがtrueに。置換ではだめ。
    'Library/Containers/jp.naver.line.mac/Data/Library/Containers/jp.naver.line/Data/LINE.ini' => [
        // サウンド通知しない
        '/alarm_sound=true/' => 'alarm_sound=false',
        // メッセージの内容表示しない
        '/alarm_toast_preview=true/' => 'alarm_toast_preview=false',
    ],
    // Slack
    'Library/Containers/com.tinyspeck.slackmacgap/Data/Library/Application Support/Slack/storage/slack-settings' => [
        // ズームレベルを-2
        // ~/Library/Containers/com.tinyspeck.slackmacgap/Data/Library/Application\ Support/Slack/Preferences
        // も触らないといけないかも？partition.per_host_zoom_levels
        '/,"zoomLevel":[0-9\-\.]+,/' => ',"zoomLevel":-2,',
    ],
];

foreach ($arr as $file => $val) {
    $filePath = $HOME . '/' . $file;
    if (! file_exists($filePath)) {
        continue;
    }

    $content = file_get_contents($filePath);
    $search_arr = array_keys($val);
    $replace_arr = array_values($val);
    $replacedContent = preg_replace($search_arr, $replace_arr, $content);

    if ($content != $replacedContent) {
        echo "\n\033[32m" . $filePath . "\033[0m\n";
        // backup
        $backupFilePath = $filePath . '.backupByIshikawa.' . sha1($content);
        file_put_contents($backupFilePath, $content);
        file_put_contents($filePath, $replacedContent);
        echo " - diff:\n";
        system('diff "' . $backupFilePath . '" "' . $filePath . '"');
        echo " - backup to: " . $backupFilePath . "\n";
    }
}
