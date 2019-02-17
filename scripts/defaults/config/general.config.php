<?php

return [
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
        // うまくいっていない
/*
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
*/
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
        'AppleAquaColorVariant' => [
            // General > Accent color = Blue (1)
            // 1: blue
            // 6: gray
            'read' => 1,
            'write' => '-int 1',
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

    'com.apple.systemuiserver' => [
        // Language and Region
        // menuExtras もやりたいけど、、array_pushがわからないので。
        'NSStatusItem Visible com.apple.menuextra.textinput' => [
            'read' => 1,
            'write' => '-bool true',
        ],

        // Network
        'NSStatusItem Visible com.apple.menuextra.vpn' => [
            'read' => 1,
            'write' => '-bool true',
        ],
    ],

    // Network
    'com.apple.networkConnect' => [
        'VPNShowTime' => [
            // Show Time Connected
            'read' => 1,
            'write' => '-bool true',
        ],

        // Network
        'NSStatusItem Visible com.apple.menuextra.vpn' => [
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

/*
todo
AttentionPrefBundleIDs で "com.apple.preferences.icloud" = 1; とかしたいけど互換性が不安
*/
