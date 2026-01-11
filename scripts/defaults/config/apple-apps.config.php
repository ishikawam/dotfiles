<?php

/**
 * Apple Apps
 */
return [
    // Terminal
    'com.apple.Terminal' => [
        // デフォルトプロファイルをProに設定
        'Default Window Settings' => [
            'read' => 'Pro',
            'write' => '-string Pro',
        ],
        // 起動時プロファイルをProに設定
        'Startup Window Settings' => [
            'read' => 'Pro',
            'write' => '-string Pro',
        ],
        // Proプロファイルの透過を無効化
        'Window\ Settings:Pro:BackgroundBlur' => [
            'read' => '0',
            'write' => '0',
        ],
    ],

     // Safari
    'com.apple.SafariCloudHistoryPushAgent' => [
        // Push通知を拒否
        'UnacknowledgedPushNotifications' => [
            'read' => 1,
            'write' => '-bool true',
        ],
        'AcknowledgedPushNotifications' => [
            'read' => 0,
            'write' => '-bool false',
        ],
    ],

    // Xcode
    'com.apple.dt.Xcode' => [
        // Push通知を拒否
        'DVTTextIndentTabWidth' => [
            'read' => 2,
            'write' => '-int 2',
        ],
        'DVTTextIndentWidth' => [
            'read' => 2,
            'write' => '-int 2',
        ],
        'DVTTextTabKeyIndentBehavior' => [
            'read' => 'Always',
            'write' => '-string Always',
        ],
    ],
];
