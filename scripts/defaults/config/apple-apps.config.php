<?php

/**
 * Apple Apps
 */
return [
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
