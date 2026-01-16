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

$HOME = exec('echo $HOME');

if (! file_exists($HOME . '/Library/')) {
    echo "macOS以外の環境です。スキップします。\n\n";
    return;
}

if (file_exists($HOME . '/this/.force-defaults')) {
    echo "=== アプリ設定ファイルを更新 ===\n\n";
} else {
    echo "スキップ: ~/this/.force-defaults が存在しません\n";
    echo "実行するには: make set-force-defaults\n\n";
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

$updated = 0;
$skipped = 0;

foreach ($arr as $file => $val) {
    $filePath = $HOME . '/' . $file;
    if (! file_exists($filePath)) {
        $skipped++;
        continue;
    }

    $content = file_get_contents($filePath);
    $search_arr = array_keys($val);
    $replace_arr = array_values($val);
    $replacedContent = preg_replace($search_arr, $replace_arr, $content);

    if ($content != $replacedContent) {
        echo "\033[32m✓\033[0m " . basename($filePath) . "\n";
        $backupFilePath = $filePath . '.backupByIshikawa.' . sha1($content);
        file_put_contents($backupFilePath, $content);
        file_put_contents($filePath, $replacedContent);
        echo "  バックアップ: " . basename($backupFilePath) . "\n";
        $updated++;
    } else {
        echo ". " . basename($filePath) . " (変更なし)\n";
    }
}

echo "\n=== 完了 ===\n";
echo "更新: {$updated}, スキップ: {$skipped}\n\n";
