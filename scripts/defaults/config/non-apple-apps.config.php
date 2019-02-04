<?php

/**
 * Non-Apple Apps
 */
return [
    // sequel pro
    'com.sequelpro.SequelPro' => [
        'SUEnableAutomaticChecks' => [
            // automatic update check.
            'read' => 1,
            'write' => '-bool true',
        ],
        'CustomQueryMaxHistoryItems' => [
            // 履歴は100まで
            'read' => 100,
            'write' => '-int 100',
        ],
        'DefaultEncodingTag' => [
            // エンコーディングをUTF8に＞文字化け対策
            'read' => 190,
            'write' => '-int 190',
        ],
        'DisplayTableViewVerticalGridlines' => [
            // グリッドラインを表示
            'read' => 1,
            'write' => '-bool true',
        ],
    ],

    // Language Switcher
    'com.TJ-HD.Language_Switcher' => [
        'SUEnableAutomaticChecks' => [
            // automatic update check.
            'read' => 1,
            'write' => '-bool true',
        ],
    ],

    // MacDown
    'com.uranusjr.macdown' => [
        'SUEnableAutomaticChecks' => [
            // automatic update check.
            'read' => 1,
            'write' => '-bool true',
        ],
    ],

    // iterm
    'com.googlecode.iterm2' => [
        'PrefsCustomFolder' => [
            // automatic update check.
            'read' => '~/Dropbox/settings/iterm_for_karabinerelements',
            'write' => '-string "~/Dropbox/settings/iterm_for_karabinerelements"',
        ],
    ],

    // Evernote
    'com.evernote.Evernote' => [
        'WebAutomaticSpellingCorrectionEnabled' => [
            // 自動校正しない
            'read' => 0,
            'write' => '-bool false',
        ],
        'WebContinuousSpellCheckingEnabled' => [
            // スペルチェックしない
            'read' => 0,
            'write' => '-bool false',
        ],
        'WebAutomaticDashSubstitutionEnabled' => [
            // その他、自動校正とことんOff
            'read' => 0,
            'write' => '-bool false',
        ],
        'WebAutomaticQuoteSubstitutionEnabled' => [
            // その他、自動校正とことんOff
            'read' => 0,
            'write' => '-bool false',
        ],
        'WebAutomaticTextReplacementEnabled' => [
            // その他、自動校正とことんOff
            'read' => 0,
            'write' => '-bool false',
        ],
        'runHelperAtLogin' => [
            'read' => 0,
            'write' => '-bool false',
        ],
        'runHelperWithoutMainApp' => [
            'read' => 0,
            'write' => '-bool false',
        ],
        'showsStatusBarItem' => [
            'read' => 0,
            'write' => '-bool false',
        ],
        'NSTableView Supports v2 listView' => [
            // リストビュー
            'read' => 1,
            'write' => '-bool true',
        ],
    ],
    'com.evernote.EvernoteHelper' => [
        // ショートカットをすべて削除
        'ShortcutRecorder newnote' => [
            'read' => "{\n}",
            'write' => '-dict',
        ],
        'ShortcutRecorder newnotewindow' => [
            'read' => "{\n}",
            'write' => '-dict',
        ],
        'ShortcutRecorder pasteboard' => [
            'read' => "{\n}",
            'write' => '-dict',
        ],
        'ShortcutRecorder screenshot' => [
            'read' => "{\n}",
            'write' => '-dict',
        ],
        'ShortcutRecorder search' => [
            'read' => "{\n}",
            'write' => '-dict',
        ],
    ],

    // Clipy
    'com.clipy-app.Clipy' => [
        'kCPYHotKeyHistoryKeyCombo' => [
            // ⌥ ⌘ V で起動
            'read' => '<62706c69 73743030 d4010203 04050618 19582476 65727369 6f6e5824 6f626a65 63747359 24617263 68697665 72542474 6f701200 0186a0a3 07081155 246e756c 6cd4090a 0b0c0d0e 0f105624 636c6173 73596d6f 64696669 65727357 6b657943 6f64655f 1010646f 75626c65 644d6f64 69666965 72738002 11090010 0908d212 1314155a 24636c61 73736e61 6d655824 636c6173 7365735f 100f4d61 676e6574 2e4b6579 436f6d62 6fa21617 5f100f4d 61676e65 742e4b65 79436f6d 626f584e 534f626a 6563745f 100f4e53 4b657965 64417263 68697665 72d11a1b 54726f6f 74800108 111a232d 32373b41 4a515b63 76787b7d 7e838e97 a9acbec7 d9dce100 00000000 00010100 00000000 00001c00 00000000 00000000 00000000 0000e3>',
            'write' => '-data 62706c6973743030d40102030405061819582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a307081155246e756c6cd4090a0b0c0d0e0f105624636c617373596d6f64696669657273576b6579436f64655f1010646f75626c65644d6f646966696572738002110900100908d2121314155a24636c6173736e616d655824636c61737365735f100f4d61676e65742e4b6579436f6d626fa216175f100f4d61676e65742e4b6579436f6d626f584e534f626a6563745f100f4e534b657965644172636869766572d11a1b54726f6f74800108111a232d32373b414a515b6376787b7d7e838e97a9acbec7d9dce10000000000000101000000000000001c000000000000000000000000000000e3',
        ],
        'kCPYHotKeySnippetKeyCombo' => [
            // 他は不要
            'read' => null,
            'write' => null,
        ],
        'kCPYHotKeyMainKeyCombo' => [
            // 他は不要
            'read' => null,
            'write' => null,
        ],
    ],

    // Better Snap Tool
    'com.hegenberg.BetterSnapTool' => [
        'launchOnStartup' => [
            // 自動起動
            'read' => 1,
            'write' => '-bool true',
        ],
        'showMenubarIcon' => [
            // メニューアイコンは非表示
            'read' => 0,
            'write' => '-bool false',
        ],
        'previewAnimationDuration' => [
            // メニューアイコンは非表示
            'read' => 0.1,
            'write' => '-float 0.1',
        ],
        // ショートカットキー
        'registeredHotkeys' => [
            'read' => '{
    0 =     {
        keyCode = 35;
        modifiers = 2304;
    };
    10 =     {
        keyCode = 45;
        modifiers = 2304;
    };
    105 =     {
        keyCode = 41;
        modifiers = 2304;
    };
    106 =     {
        keyCode = 39;
        modifiers = 2304;
    };
    13 =     {
        keyCode = 47;
        modifiers = 2304;
    };
    14 =     {
        keyCode = 44;
        modifiers = 2304;
    };
    17 =     {
        keyCode = 123;
        modifiers = 8390912;
    };
    2 =     {
        keyCode = 33;
        modifiers = 2304;
    };
    4 =     {
        keyCode = 30;
        modifiers = 2304;
    };
    8 =     {
        keyCode = 124;
        modifiers = 8390912;
    };
}',
            'write' => '-dict',
        ],
        'registeredHotkeys:0:keyCode' => [
            'read' => 35,
            'write' => 'integer 35',
        ],
        'registeredHotkeys:0:modifiers' => [
            'read' => 2304,
            'write' => 'integer 2304',
        ],
        'registeredHotkeys:2:keyCode' => [
            'read' => 33,
            'write' => 'integer 33',
        ],
        'registeredHotkeys:2:modifiers' => [
            'read' => 2304,
            'write' => 'integer 2304',
        ],
        'registeredHotkeys:4:keyCode' => [
            'read' => 30,
            'write' => 'integer 30',
        ],
        'registeredHotkeys:4:modifiers' => [
            'read' => 2304,
            'write' => 'integer 2304',
        ],
        'registeredHotkeys:8:keyCode' => [
            'read' => 124,
            'write' => 'integer 124',
        ],
        'registeredHotkeys:8:modifiers' => [
            'read' => 8390912,
            'write' => 'integer 8390912',
        ],
        'registeredHotkeys:10:keyCode' => [
            'read' => 45,
            'write' => 'integer 45',
        ],
        'registeredHotkeys:10:modifiers' => [
            'read' => 2304,
            'write' => 'integer 2304',
        ],
        'registeredHotkeys:13:keyCode' => [
            'read' => 47,
            'write' => 'integer 47',
        ],
        'registeredHotkeys:13:modifiers' => [
            'read' => 2304,
            'write' => 'integer 2304',
        ],
        'registeredHotkeys:14:keyCode' => [
            'read' => 44,
            'write' => 'integer 44',
        ],
        'registeredHotkeys:14:modifiers' => [
            'read' => 2304,
            'write' => 'integer 2304',
        ],
        'registeredHotkeys:17:keyCode' => [
            'read' => 123,
            'write' => 'integer 123',
        ],
        'registeredHotkeys:17:modifiers' => [
            'read' => 8390912,
            'write' => 'integer 8390912',
        ],
        'registeredHotkeys:105:keyCode' => [
            'read' => 41,
            'write' => 'integer 41',
        ],
        'registeredHotkeys:105:modifiers' => [
            'read' => 2304,
            'write' => 'integer 2304',
        ],
        'registeredHotkeys:106:keyCode' => [
            'read' => 39,
            'write' => 'integer 39',
        ],
        'registeredHotkeys:106:modifiers' => [
            'read' => 2304,
            'write' => 'integer 2304',
        ],
        //
        'nextMonitorMoveWarningShowed' => [
            // next monitor move の警告を出さない
            'read' => 1,
            'write' => '-bool true',
        ],
    ],
];
