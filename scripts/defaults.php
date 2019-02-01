<?php

/**
 * defaultsを使うのとPlistBuddyを使うのとをいまは混在させているけど、たぶんPlistBuddyに統一したほうがスマートになる
 * https://qiita.com/djmonta/items/17531dde1e82d9786816
 */

echo "\n\n### defaults.php ###\n\n";

if (exec('which defaults 2>/dev/null') == '') {
    echo "No `defaults`. Do nothing.\n\n";
    return;
}


$HOME = exec('echo $HOME');

$arr = [
    // sudo user
    '/Library/Preferences/com.apple.loginwindow' => [
        'LoginwindowText' => [
            // ロックスクリーンメッセージ 紛失時用
            'read' => "\u77f3\u5ddd\u5c06\u884c\n090-2442-9581\nishikawam@nifty.com",
            'write' => "-string \"石川将行\n090-2442-9581\nishikawam@nifty.com\"",
            'sudo' => true,
        ],
    ],

    // general user
    'com.apple.dock' => [
        'autohide' => [
            // Automatically hide or show the Dock （Dock を自動的に隠す）
            'read' => 1,
            'write' => '-bool true',
        ],
        'expose-group-apps' => [
            // Don’t group windows by application in Mission Control
            // (i.e. use the old Exposé behavior instead)
            'read' => 1,
            'write' => '-bool true',
        ],
        'largesize' => [
            // ?
            'read' => 59,
            'write' => '-int 59',
        ],
        'magnification' => [
            // Magnificate the Dock （Dock の拡大機能を入にする）
            'read' => 1,
            'write' => '-bool true',
        ],
        'orientation' => [
            // ? たぶん位置
            'read' => 'left',
            'write' => '-string left',
        ],
        'region' => [
            'read' => 'JP',
            'write' => '-string JP',
        ],
        'showAppExposeGestureEnabled' => [
            // ? たぶんExposeのアニメ？ジェスチャー？
            'read' => 1,
            'write' => '-bool true',
        ],
        'showMissionControlGestureEnabled' => [
            // ? たぶんMissionControlのアニメ？ジェスチャー？
            'read' => 1,
            'write' => '-bool true',
        ],
        'tilesize' => [
            // Set the icon size （アイコンサイズの設定）
            'read' => 53,
            'write' => '-int 53',
        ],
        // Hot corners （Mission Control のホットコーナーの設定）
        // Possible values:
        //  0: no-op
        //  2: Mission Control
        //  3: Show application windows
        //  4: Desktop
        //  5: Start screen saver
        //  6: Disable screen saver
        //  7: Dashboard
        // 10: Put display to sleep
        // 11: Launchpad
        // 12: Notification Center
        'wvous-bl-corner' => [
            // 下左
            'read' => 5,
            'write' => '-int 5',
        ],
        'wvous-bl-modifier' => [
            // 下左
            'read' => 0,
            'write' => '-int 0',
        ],
        'wvous-br-corner' => [
            // 下右
            'read' => 10,
            'write' => '-int 10',
        ],
        'wvous-br-modifier' => [
            // 下右
            'read' => 0,
            'write' => '-int 0',
        ],
    ],
    'com.apple.finder' => [
        'ComputerViewSettings:WindowState:ContainerShowSidebar' => [
            // なんだっけ？
            'read' => 'true',
            'write' => 'true',
        ],
        'AppleShowAllFiles' => [
            // 不可視ファイルを可視化する
            'read' => 1,
            'write' => '-bool true',
        ],
        'NewWindowTarget' => [
            // 新しいウィンドウでデフォルトでホームフォルダを開く
            'read' => 'PfHm',
            'write' => '-string PfHm',
        ],
        'NewWindowTargetPath' => [
            // 新しいウィンドウでデフォルトでホームフォルダを開く
            'read' => 'file://' . $HOME . '/',
            'write' => '-string file://' . $HOME . '/',
        ],
        'ShowStatusBar' => [
            // Show Status bar in Finder （ステータスバーを表示）
            'read' => 1,
            'write' => '-bool true',
        ],
        'ShowPathbar' => [
            // Show Path bar in Finder （パスバーを表示）
            'read' => 1,
            'write' => '-bool true',
        ],
        'ShowTabView' => [
            // Show Tab bar in Finder （タブバーを非表示）
            'read' => 0,
            'write' => '-bool false',
        ],
        'ShowExternalHardDrivesOnDesktop' => [
            // Show icons for hard drives, servers, and removable media on the desktop
            'read' => 1,
            'write' => '-bool true',
        ],
        'ShowHardDrivesOnDesktop' => [
            // Show icons for hard drives, servers, and removable media on the desktop
            'read' => 1,
            'write' => '-bool true',
        ],
        'ShowMountedServersOnDesktop' => [
            // Show icons for hard drives, servers, and removable media on the desktop
            'read' => 1,
            'write' => '-bool true',
        ],
        'ShowRemovableMediaOnDesktop' => [
            // Show icons for hard drives, servers, and removable media on the desktop
            'read' => 1,
            'write' => '-bool true',
        ],
        'ShowRemovableMediaOnDesktop' => [
            // Show icons for hard drives, servers, and removable media on the desktop
            'read' => 1,
            'write' => '-bool true',
        ],
        'FXDefaultSearchScope' => [
            // When performing a search, search the current folder by default
            'read' => 'SCcf',
            'write' => '-string SCcf',
        ],
        'FXEnableExtensionChangeWarning' => [
            // Disable the warning when changing a file extension
            'read' => 0,
            'write' => '-bool false',
        ],
        'DesktopViewSettings:IconViewSettings:showItemInfo' => [
            // Show item info near icons on the desktop and in other icon views
            'read' => 'false',
            'write' => 'false',
        ],
        'FK_StandardViewSettings:IconViewSettings:showItemInfo' => [
            // Show item info near icons on the desktop and in other icon views
            'read' => 'false',
            'write' => 'false',
        ],
        'StandardViewSettings:IconViewSettings:showItemInfo' => [
            // Show item info near icons on the desktop and in other icon views
            'read' => 'false',
            'write' => 'false',
        ],
        'FXPreferredViewStyle' => [
            // Use list view in all Finder windows by default
            // Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
            // 「Nlsv」リストビュー 「icnv」（アイコンビュー）、「clmv」（カラムビュー）、「Flwv」（カバーフロービュー）
            'read' => 'Nlsv',
            'write' => '-string Nlsv',
        ],
        'FXRemoveOldTrashItems' => [
            // Remove items from the Trash after 30 days
            'read' => 1,
            'write' => '-bool true',
        ],


/*
# やってもいいかも

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true
*/
    ],

    'com.apple.desktopservices' => [
        // Avoid creating .DS_Store files on network or USB volumes
        'DSDontWriteNetworkStores' => [
            'read' => 1,
            'write' => '-bool true',
        ],
        'DSDontWriteUSBStores' => [
            'read' => 1,
            'write' => '-bool true',
        ],
    ],

    'com.apple.LaunchServices' => [
        // git addした。 デフォルトでどのアプリを開くかを定義。ex. デフォルトブラウザ=Chrome
    ],

    'com.apple.iCal' => [
        // カレンダー
        // デフォルトカレンダー CalDefaultCalendar は「予定表」にしたいが、デバイスごとでハッシュが異なるのでできない。
        // 通知もできない。結構手動でやるしかない。
        'first day of week' => [
            // 先頭を月曜日に AppleFirstWeekdayでやってるけども。
            'read' => 1,
            'write' => '-int 1',
        ],
        'first minute of work hours' => [
            // 1日の開始時間 8:00
            'read' => 480,
            'write' => '-int 480',
        ],
        'last minute of work hours' => [
            // 1日の終了時間 20:00
            'read' => 1200,
            'write' => '-int 1200',
        ],
    ],

    // Keyboard shortcuts
    'com.apple.symbolichotkeys' => [
        // 60: Keyborad > Shortcuts > Input Sources > Select the previous input source = ⌘ Space
        'AppleSymbolicHotKeys:60:enabled' => [
            'read' => 'true',
            'write' => 'true',
        ],
        'AppleSymbolicHotKeys:60:value:parameters:0' => [
            'read' => 32,
            'write' => 32,
        ],
        'AppleSymbolicHotKeys:60:value:parameters:1' => [
            'read' => 49,
            'write' => 49,
        ],
        'AppleSymbolicHotKeys:60:value:parameters:2' => [
            'read' => 1048576,
            'write' => 1048576,
        ],
        // 61: Keyborad > Shortcuts > Input Sources > Select next soruce in Input menu = OFF
        'AppleSymbolicHotKeys:64:enabled' => [
            'read' => 'false',
            'write' => 'false',
        ],
        // 64: Keyborad > Shortcuts > Spotlight > Show Spotlight search = OFF
        'AppleSymbolicHotKeys:64:enabled' => [
            'read' => 'false',
            'write' => 'false',
        ],
        // 65: Keyborad > Shortcuts > Spotlight > Show Finder search window = OFF
        'AppleSymbolicHotKeys:65:enabled' => [
            'read' => 'false',
            'write' => 'false',
        ],
        // 27: Keyborad > Shortcuts > Keyboard > Move focus to next window = ⌘ F1
        'AppleSymbolicHotKeys:27:enabled' => [
            'read' => 'true',
            'write' => 'true',
        ],
        'AppleSymbolicHotKeys:27:value:parameters:0' => [
            'read' => 65535,
            'write' => 65535,
        ],
        'AppleSymbolicHotKeys:27:value:parameters:1' => [
            'read' => 122,
            'write' => 122,
        ],
        'AppleSymbolicHotKeys:27:value:parameters:2' => [
            'read' => 9437184,
            'write' => 9437184,
        ],
    ],
    // Keyborad - Input Source
    'com.apple.HIToolbox' => [
        // Google日本語入力
        'AppleSelectedInputSources' => [
            'read' => '(
        {
        "Bundle ID" = "com.apple.inputmethod.EmojiFunctionRowItem";
        InputSourceKind = "Non Keyboard Input Method";
    },
        {
        "Bundle ID" = "com.google.inputmethod.Japanese";
        "Input Mode" = "com.apple.inputmethod.Japanese";
        InputSourceKind = "Input Mode";
    }
)',
            'write' => '-array \'{"Bundle ID" = "com.apple.inputmethod.EmojiFunctionRowItem"; InputSourceKind = "Non Keyboard Input Method";}\' \'{"Bundle ID" = "com.google.inputmethod.Japanese"; "Input Mode" = "com.apple.inputmethod.Japanese"; InputSourceKind = "Input Mode";}\'',
        ],
    ],

    // Accessibility
    'com.apple.universalaccess' => [
        // Use scroll gesture with the Ctrl (^) modifier key to zoom
        'closeViewScrollWheelToggle' => [
            'read' => 1,
            'write' => '-bool true',
        ],
    ],


    /**
     * Apple Apps
     */

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

    /**
     * Non-Apple Apps
     */

    // sequel pro
    'com.sequelpro.SequelPro' => [
        'SUEnableAutomaticChecks' => [
            // automatic update check.
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

    /**
     * Apple Global Domain
     */
    '-g' => [  // = NSGlobalDomain
        // Language and Region
        'NSLinguisticDataAssetsRequested' => [
            'read' => '(
    en,
    "en_JP",
    ja,
    "ja_JP"
)',
            'write' => '-array en "en_JP" ja "ja_JP"',
        ],
        'AppleLanguages' => [
            'read' => '(
    "en-JP",
    "ja-JP"
)',
            'write' => '-array "en-JP" "ja-JP"',
        ],
        'AppleMeasurementUnits' => [
            'read' => 'Centimeters',
            'write' => '-string Centimeters',
        ],
        'AppleMetricUnits' => [
            'read' => 1,
            'write' => '-bool true',
        ],
        'AppleTemperatureUnit' => [
            'read' => 'Celsius',
            'write' => '-string Celsius',
        ],
        'AppleFirstWeekday' => [
            // 先頭を月曜日に
            'read' => '{
    gregorian = 2;
}',
            'write' => '-dict gregorian 2',
        ],
        // Keyboard 自動構成 全てOff
        'NSAutomaticCapitalizationEnabled' => [
            'read' => 0,
            'write' => '-bool false',
        ],
        'NSAutomaticSpellingCorrectionEnabled' => [
            // Disable auto-correct
            'read' => 0,
            'write' => '-bool false',
        ],
        'NSAutomaticDashSubstitutionEnabled' => [
            // Disable smart dashes as they’re annoying when typing code
            'read' => 0,
            'write' => '-bool false',
        ],
        'NSAutomaticQuoteSubstitutionEnabled' => [
            // Disable smart quotes as they’re annoying when typing code
            'read' => 0,
            'write' => '-bool false',
        ],
        'NSAutomaticPeriodSubstitutionEnabled' => [
            // Disable automatic period substitution as it’s annoying when typing code
            'read' => 0,
            'write' => '-bool false',
        ],
        'NSAutomaticTextCompletionEnabled' => [
            'read' => 0,
            'write' => '-bool false',
        ],
        'WebAutomaticSpellingCorrectionEnabled' => [
            'read' => 0,
            'write' => '-bool false',
        ],

        // Keyboard
        'KeyRepeat' => [
            // default 2
            'read' => 1.2,
            'write' => '-float 1.2',
        ],
        'InitialKeyRepeat' => [
            // default 15
            'read' => 10,
            'write' => '-int 10',
        ],
        'com.apple.keyboard.fnState' => [
            // Use F1, F2, etc. keys as standard function keys.
            // 本当はデフォルトのfalseにしたいけど、karabiner-elementsのoption+numberが対応していないので、、
            'read' => 1,
            'write' => '-bool true',
        ],

        // Trackpad
        'com.apple.trackpad.forceClick' => [
            // 新Trackpadの強く押し込む を無効に Look up & data detectors ; Force click with one finger
            'read' => 0,
            'write' => '-bool false',
        ],
        'com.apple.trackpad.scaling' => [
            // Tracking speed
            'read' => 1.5,
            'write' => '-float 1.5',
        ],

        // Finder
        'NSTableViewDefaultSizeMode' => [
            // ### [システム環境設定]，[一般] の pmn[サイドバーのアイコンサイズ] デフォルト2
//            'read' => 2,
//            'write' => '-int 2',
        ],
        'AppleShowAllExtensions' => [
            // Finder: show all filename extensions
            'read' => 1,
            'write' => '-bool true',
        ],
        'NSQuitAlwaysKeepsWindows' => [
            // General > Close windows when quitting an app = off
            // アプリケーションを終了して再度開くときにウィンドウを復元
            'read' => 1,
            'write' => '-bool true',
        ],
    ],

    // Trackpad
    'com.apple.AppleMultitouchTrackpad' => [
        'ActuateDetents' => [
            // 新Trackpadの強く押し込む を無効に Force Click and haptic feedback
            'read' => 0,
            'write' => '-bool false',
        ],
        'Clicking' => [
            // Tap to click
            'read' => 1,
            'write' => '-bool true',
        ],
        'Dragging' => [
            // ダブルタップでドラッグ開始
            'read' => 1,
            'write' => '-bool true',
        ],
        'DragLock' => [
            // その場合、タップしないとドラッグ解除しない
            'read' => 1,
            'write' => '-bool true',
        ],
        'ForceSuppressed' => [
            // 新Trackpadの強く押し込む を無効に Force Click and haptic feedback
            'read' => 1,
            'write' => '-bool true',
        ],
        'TrackpadThreeFingerHorizSwipeGesture' => [
            // 4本指に
            'read' => 0,
            'write' => '-int 0',
        ],
        'TrackpadThreeFingerVertSwipeGesture' => [
            // 4本指に
            'read' => 0,
            'write' => '-int 0',
        ],
        'TrackpadThreeFingerDrag' => [
            // 3本指ドラッグ
            'read' => 1,
            'write' => '-bool true',
        ],
        'HIDScrollZoomModifierMask' => [
            // Ctrol+Trackpad = zoom
            'read' => 262144,
            'write' => '-int 262144',
        ],
    ],
    'com.apple.driver.AppleBluetoothMultitouch.trackpad' => [
        'Clicking' => [
            // Tap to click
            'read' => 1,
            'write' => '-bool true',
        ],
        'Dragging' => [
            // ダブルタップでドラッグ開始
            'read' => 1,
            'write' => '-bool true',
        ],
        'DragLock' => [
            // その場合、タップしないとドラッグ解除しない
            'read' => 1,
            'write' => '-bool true',
        ],
        'TrackpadThreeFingerHorizSwipeGesture' => [
            // 4本指に
            'read' => 0,
            'write' => '-int 0',
        ],
        'TrackpadThreeFingerVertSwipeGesture' => [
            // 4本指に
            'read' => 0,
            'write' => '-int 0',
        ],
        'TrackpadThreeFingerDrag' => [
            // 3本指ドラッグ
            'read' => 1,
            'write' => '-bool true',
        ],
        'HIDScrollZoomModifierMask' => [
            // Ctrol+Trackpad = zoom
            'read' => 262144,
            'write' => '-int 262144',
        ],
    ],
    'com.apple.preference.trackpad' => [
        'ForceClickSavedState' => [
            // 新Trackpadの強く押し込む を無効に Force Click and haptic feedback
            'read' => 0,
            'write' => '-bool false',
        ],
    ],

    // Language and Region
    'com.apple.systemuiserver' => [
        // menuExtras もやりたいけど、、array_pushがわからないので。
        'NSStatusItem Visible com.apple.menuextra.textinput' => [
            'read' => 1,
            'write' => '-bool true',
        ],
    ],

    // menuextra : show percentage
    'com.apple.menuextra.battery' => [
        'ShowPercent' => [
            // バッテリーのパーセントを表示
            'read' => 'YES',
            'write' => '-string YES',
        ],
    ],

    // Date & Time > Clock
    'com.apple.menuextra.clock' => [
        'DateFormat' => [
            // Date options: Show the day of the week: on （日付表示設定、曜日を表示）
            'read' => 'EEE H:mm',
            'write' => '-string "EEE H:mm"',
        ],
        'FlashDateSeparators' => [
            // Flash the time separators
            'read' => 1,
            'write' => '-bool true',
        ],
        'IsAnalog' => [
            // Digital or Analog
            'read' => 0,
            'write' => '-bool false',
        ],
    ],

    // Activity Monitor
    'com.apple.ActivityMonitor' => [
        'IconType' => [
            // Visualize CPU usage in the Activity Monitor Dock icon
            'read' => '6',
            'write' => '-int 6',
        ],
    ],

    // Spotlight
    'com.apple.Spotlight' => [
        'orderedItems' => [
            'read' => '(
        {
        enabled = 1;
        name = APPLICATIONS;
    },
        {
        enabled = 0;
        name = "MENU_SPOTLIGHT_SUGGESTIONS";
    },
        {
        enabled = 0;
        name = "MENU_CONVERSION";
    },
        {
        enabled = 0;
        name = "MENU_EXPRESSION";
    },
        {
        enabled = 0;
        name = "MENU_DEFINITION";
    },
        {
        enabled = 0;
        name = "SYSTEM_PREFS";
    },
        {
        enabled = 0;
        name = DOCUMENTS;
    },
        {
        enabled = 0;
        name = DIRECTORIES;
    },
        {
        enabled = 0;
        name = PRESENTATIONS;
    },
        {
        enabled = 0;
        name = SPREADSHEETS;
    },
        {
        enabled = 0;
        name = PDF;
    },
        {
        enabled = 0;
        name = MESSAGES;
    },
        {
        enabled = 0;
        name = CONTACT;
    },
        {
        enabled = 1;
        name = "EVENT_TODO";
    },
        {
        enabled = 0;
        name = IMAGES;
    },
        {
        enabled = 0;
        name = BOOKMARKS;
    },
        {
        enabled = 0;
        name = MUSIC;
    },
        {
        enabled = 0;
        name = MOVIES;
    },
        {
        enabled = 0;
        name = FONTS;
    },
        {
        enabled = 0;
        name = "MENU_OTHER";
    },
        {
        enabled = 0;
        name = SOURCE;
    }
)',
            'write' => '-array \
	\'{"enabled" = 1;"name" = "APPLICATIONS";}\' \
	\'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}\' \
	\'{"enabled" = 0;"name" = "MENU_CONVERSION";}\' \
	\'{"enabled" = 0;"name" = "MENU_EXPRESSION";}\' \
	\'{"enabled" = 0;"name" = "MENU_DEFINITION";}\' \
	\'{"enabled" = 0;"name" = "SYSTEM_PREFS";}\' \
	\'{"enabled" = 0;"name" = "DOCUMENTS";}\' \
	\'{"enabled" = 0;"name" = "DIRECTORIES";}\' \
	\'{"enabled" = 0;"name" = "PRESENTATIONS";}\' \
	\'{"enabled" = 0;"name" = "SPREADSHEETS";}\' \
	\'{"enabled" = 0;"name" = "PDF";}\' \
	\'{"enabled" = 0;"name" = "MESSAGES";}\' \
	\'{"enabled" = 0;"name" = "CONTACT";}\' \
	\'{"enabled" = 1;"name" = "EVENT_TODO";}\' \
	\'{"enabled" = 0;"name" = "IMAGES";}\' \
	\'{"enabled" = 0;"name" = "BOOKMARKS";}\' \
	\'{"enabled" = 0;"name" = "MUSIC";}\' \
	\'{"enabled" = 0;"name" = "MOVIES";}\' \
	\'{"enabled" = 0;"name" = "FONTS";}\' \
	\'{"enabled" = 0;"name" = "MENU_OTHER";}\' \
	\'{"enabled" = 0;"name" = "SOURCE";}\' \
',
//	\'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}\' \
        ],
    ],
];


foreach ($arr as $com => $tmp) {
    foreach ($tmp as $attr => $val) {
        $sudo = $val['sudo'] ?? false;
        $sudoCommand = $sudo ? 'sudo ' : '';
        $out = null;
        $val['read'] = $val['read'] ?? null;
        if (strpos($attr, ':')) {
            exec($sudoCommand . '/usr/libexec/PlistBuddy -c "print :' . $attr . '" ~/Library/Preferences/' . $com . '.plist', $out);
        } else {
            exec($sudoCommand . 'defaults read ' . $com . ' "' . $attr . '"' . ($val['read'] === null ? ' 2>/dev/null' : '') , $out);
        }
        $read = implode("\n", $out);
        if ($read == '' && $val['read'] !== null) {
            echo "\n\033[31mError. $com $attr\033[0m\n";
        }

        if ($val['read'] === null) {
            // delete
            if ($read == '') {
                // skip delete
//                echo "skip deleting... $com $attr : $read\n";
                echo '.';
                continue;
            }
        } else {
            if (! isset($val['write']) || $read === (string)$val['read']) {
//                echo "skip... $com $attr : $read\n";
                echo '.';
                continue;
            }
        }

        $out = null;
        if (($argv[1] ?? null) != '--dry-run') {
            if (strpos($attr, ':')) {
                // setかaddで。ちゃんと判定したい。@todo;
                exec($sudoCommand . '/usr/libexec/PlistBuddy -c "set :' . $attr . ' ' . $val['write'] . '" ~/Library/Preferences/' . $com . '.plist');
                exec($sudoCommand . '/usr/libexec/PlistBuddy -c "add :' . $attr . ' ' . $val['write'] . '" ~/Library/Preferences/' . $com . '.plist');
                exec($sudoCommand . '/usr/libexec/PlistBuddy -c "print :' . $attr . '" ~/Library/Preferences/' . $com . '.plist', $out);
            } else {
                if ($val['read'] === null) {
                    // $val['read'] = null は削除
                    exec($sudoCommand . 'defaults delete ' . $com . ' "' . $attr . '"');
                } else {
                    exec($sudoCommand . 'defaults write ' . $com . ' "' . $attr . '" ' . $val['write']);
                    exec($sudoCommand . 'defaults read ' . $com . ' "' . $attr . '"', $out);
                }
            }
        } else {
            echo "\n\033[32m(dry-run)\033[0m";
        }

        if ($val['read'] === null) {
            echo "\n$com $attr : \033[32mDeleted.\033[0m\n";
        } else {
            $readAfter = implode("\n", $out);
            echo "\n$com $attr : \033[32m$read -> $readAfter\033[0m\n";
        }
    }
}

echo "\n\nDONE. plaese restart mac.\n\n";


/*

# Enable `Tap to click` （タップでクリックを有効にする）
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Map bottom right Trackpad corner to right-click （右下をクリックで、副クリックに割り当てる）
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true







# Automatically quit the printer app once the print jobs are completed
# 印刷が終了したら、自動的にプリンターアプリを終了する
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Save screenshots as PNGs （スクリーンショット保存形式をPNGにする）
defaults write com.apple.screencapture type -string "png"

# Require password immediately after the computer went into
# sleep or screen saver mode （スリープまたはスクリーンセーバから復帰した際、パスワードをすぐに要求する）
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Expand save panel by default （保存パネルをデフォルトで開いた状態にする）
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default （印刷パネルをデフォルトで開いた状態にする）
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Hide the Time Machine and Volume icons from the menu bar （メニューバーのTime Machine と音量アイコンを非表示にする）
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
    sudo defaults write "${domain}" dontAutoLoad -array \
        "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
        "/System/Library/CoreServices/Menu Extras/Volume.menu"
done














### https://github.com/mathiasbynens/dotfiles/blob/master/.macos




# ~/.macos — https://mths.be/macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################


# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable transparency in the menu bar and elsewhere on Yosemite
defaults write com.apple.universalaccess reduceTransparency -bool true

# Set highlight color to green
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true


# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true


# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
#defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > ~/.CFUserTextEncoding

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off > /dev/null

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null






# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf ~/Library/Application Support/Dock/desktoppicture.db
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0


###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false


# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Brussels" > /dev/null

# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true



###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable continuous spellchecking
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable plug-ins
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Disable Java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Disable auto-playing video
#defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
#defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
#defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
#defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Disable send and reply animations in Mail.app
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

# Display emails in threaded mode, sorted by date (oldest at the top)
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

# Disable inline attachments (just show the icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
# 	MENU_DEFINITION
# 	MENU_CONVERSION
# 	MENU_EXPRESSION
# 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# 	MENU_WEBSEARCH             (send search queries to Apple)
# 	MENU_OTHER
# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Use a modified version of the Solarized Dark theme by default in Terminal.app
osascript <<EOD
tell application "Terminal"
	local allOpenedWindows
	local initialOpenedWindows
	local windowID
	set themeName to "Solarized Dark xterm-256color"
	(* Store the IDs of all the open terminal windows. *)
	set initialOpenedWindows to id of every window
	(* Open the custom theme so that it gets added to the list
	   of available terminal themes (note: this will open two
	   additional terminal windows). *)
	do shell script "open '$HOME/init/" & themeName & ".terminal'"
	(* Wait a little bit to ensure that the custom theme is added. *)
	delay 1
	(* Set the custom theme as the default terminal theme. *)
	set default settings to settings set themeName
	(* Get the IDs of all the currently opened terminal windows. *)
	set allOpenedWindows to id of every window
	repeat with windowID in allOpenedWindows
		(* Close the additional windows that were opened in order
		   to add the custom theme to the list of terminal themes. *)
		if initialOpenedWindows does not contain windowID then
			close (every window whose id is windowID)
		(* Change the theme for the initial opened terminal windows
		   to remove the need to close them in order for the custom
		   theme to be applied. *)
		else
			set current settings of tabs of (every window whose id is windowID) to settings set themeName
		end if
	end repeat
end tell
EOD

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it without clicking first
#defaults write com.apple.terminal FocusFollowsMouse -bool true
#defaults write org.x.X11 wm_ffm -bool true

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Disable the annoying line marks
defaults write com.apple.Terminal ShowLineMarks -int 0


###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal


###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
defaults write com.apple.dashboard devmode -bool true


# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

# Auto-play videos when opened with QuickTime Player
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Messages                                                                    #
###############################################################################

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# GPGMail 2                                                                   #
###############################################################################

# Disable signing emails by default
defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false

###############################################################################
# Opera & Opera Developer                                                     #
###############################################################################

# Expand the print dialog by default
defaults write com.operasoftware.Opera PMPrintingExpandedStateForPrint2 -boolean true
defaults write com.operasoftware.OperaDeveloper PMPrintingExpandedStateForPrint2 -boolean true

###############################################################################
# SizeUp.app                                                                  #
###############################################################################

# Start SizeUp at login
defaults write com.irradiatedsoftware.SizeUp StartAtLogin -bool true

# Don’t show the preferences window on next start
defaults write com.irradiatedsoftware.SizeUp ShowPrefsOnNextStart -bool false

###############################################################################
# Sublime Text                                                                #
###############################################################################

# Install Sublime Text settings
cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings 2> /dev/null

###############################################################################
# Spectacle.app                                                               #
###############################################################################

# Set up my preferred keyboard shortcuts
cp -r init/spectacle.json ~/Library/Application\ Support/Spectacle/Shortcuts.json 2> /dev/null

###############################################################################
# Transmission.app                                                            #
###############################################################################

# Use `~/Documents/Torrents` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Use `~/Downloads` to store completed downloads
defaults write org.m0k.transmission DownloadLocationConstant -bool true

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Don’t prompt for confirmation before removing non-downloading active transfers
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

# IP block list.
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Randomize port on launch
defaults write org.m0k.transmission RandomPort -bool true

###############################################################################
# Twitter.app                                                                 #
###############################################################################

# Disable smart quotes as it’s annoying for code tweets
defaults write com.twitter.twitter-mac AutomaticQuoteSubstitutionEnabled -bool false

# Show the app window when clicking the menu bar icon
defaults write com.twitter.twitter-mac MenuItemBehavior -int 1

# Enable the hidden ‘Develop’ menu
defaults write com.twitter.twitter-mac ShowDevelopMenu -bool true

# Open links in the background
defaults write com.twitter.twitter-mac openLinksInBackground -bool true

# Allow closing the ‘new tweet’ window by pressing `Esc`
defaults write com.twitter.twitter-mac ESCClosesComposeWindow -bool true

# Show full names rather than Twitter handles
defaults write com.twitter.twitter-mac ShowFullNames -bool true

# Hide the app in the background if it’s not the front-most window
defaults write com.twitter.twitter-mac HideInBackground -bool true

###############################################################################
# Tweetbot.app                                                                #
###############################################################################

# Bypass the annoyingly slow t.co URL shortener
defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome Canary" \
	"Google Chrome" \
	"Mail" \
	"Messages" \
	"Opera" \
	"Photos" \
	"Safari" \
	"SizeUp" \
	"Spectacle" \
	"SystemUIServer" \
	"Terminal" \
	"Transmission" \
	"Tweetbot" \
	"Twitter" \
	"iCal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."










### http://baqamore.hatenablog.com/entry/2013/07/31/222438



# Menu bar: disable transparency
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
### [システム環境]，[デスクトップとスクリーンセーバ] のchb[半透明メニューバー]
### -> "オフ" (半透明にしない)



# Set highlight color to green
defaults write NSGlobalDomain AppleHighlightColor -string '0.764700 0.976500 0.568600'
### [システム環境設定]，[一般] の pmn[強調表示色]
### -> [グリーン]


# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`
### [システム環境設定]，[一般] の rbt[スクロールバーの表示]
### -> [常に表示]

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false
### (略)

# Disable opening and closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
### (無; ウィンドウが開閉時のアニメーション)
### -> false (アニメーションさせない)

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
### (無; シート表示のアニメーションスピード)
### -> 0.001 秒 (速くしている)

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
### (無; 保存ダイアログのデフォルト表示スタイル)
### -> true (常に詳細な情報を開いて表示)

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
### (略) プリンタ持っていない．...というか要らないしw

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
### (無; icloud 対応アプリでのファイル保存時のデフォルトを icloud にする)
### -> false (icloud をデフォルト保存先としない)

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
### (略)


# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
### (無; ascii 制御文字の表示)
### -> true (表示する)


# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
### (無; automatic termination 機能の無効)
### -> true (無効にする)

# Disable the crash reporter
#defaults write com.apple.CrashReporter DialogType -string "none"
### (無; クラッシュリポーターダイアログの表示)
### -> none (表示しない)

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true
### (無; ヘルプの常時前面表示)
### -> true (常時前面表示しない)

# Fix for the ancient UTF-8 bug in QuickLook (http://mths.be/bbo)
# Commented out, as this is known to cause problems when saving files in
# Adobe Illustrator CS5 :(
#echo "0x08000100:0" > ~/.CFUserTextEncoding
### (略)



# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

*/



/* コントロールしないと決めているもの

# Menu bar: hide the useless Time Machine and Volume icons
com.apple.systemuiserver menuExtras



*/


