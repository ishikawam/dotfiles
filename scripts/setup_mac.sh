#!/bin/bash

head () {
    printf "\n\e[32m$1\e[m\n"
}

# mac only
if [ "`uname`" != "Darwin" ]; then
    echo "Mac以外では実行されません。"
    exit
fi

hostname=`hostname`

if [[ -e ~/this/.force-defaults ]]; then
    # ~/this/.force-defaults があったら実行
    echo
else
    echo "このホスト ($hostname) では実行されません。"
    echo "実行するには以下を実行してください: make set-force-defaults"
    exit
fi

head "### Setup Mac ###"

######## mac xcode ##################################################################

head "0. xcode-select"

if [ ! "$SSH_CLIENT" ]; then
    # mac端末上なら実行
    # @todo; caskも？masは？
    xcode-select --install 2>/dev/null
fi

######## mac rosetta 2 ##################################################################

head "0.1. rosetta 2"

# google japanese inputで必要
# Apple SiliconならRosetta 2をインストール
if [ "$(uname -m)" = "arm64" ]; then
    if ! /usr/bin/pgrep oahd >/dev/null 2>&1; then
        echo "Rosetta 2をインストールします"
        sudo softwareupdate --install-rosetta --agree-to-license
    else
        echo "Rosetta 2はインストール済みです"
    fi
else
    echo "Intel Macのため、Rosetta 2は不要です"
fi

######## mac homebrew ##################################################################

head "1. homebrew"

if ! type brew >/dev/null 2>&1 ; then
    # http://brew.sh/index_ja.html
    echo "Homebrewをインストールします。"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    # インストール直後にPATHを設定
    if [ -f /opt/homebrew/bin/brew ]; then
        echo "Apple Silicon用のHomebrewをPATHに追加"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        echo "Intel用のHomebrewをPATHに追加"
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # 確認
    if ! type brew >/dev/null 2>&1 ; then
        echo "エラー: Homebrewのインストールに失敗しました"
        echo "手動で以下を実行してください:"
        echo "  source ~/.zshrc"
        echo "  make setup"
        exit 1
    fi

    echo "Homebrewのインストールが完了しました"
fi
brew doctor
brew update
brew upgrade --quiet
brew upgrade --cask --quiet
brew install --quiet \
    tmux git tig git-lfs gh colordiff \
    emacs gnu-sed global \
    mysql-client@8.4 \
    wget jq tree trash coreutils peco imagemagick telnet rsync \
    ruby rbenv ruby-build composer \
    nodenv npm \
    java \
    awscli amazon-ecs-cli google-cloud-sdk \
    asdf direnv \
    mas \
    dannystewart/apps/volumehud

# swiftlint (Xcode.appが必要、エラーでも継続)
brew install --quiet swiftlint 2>/dev/null || echo "swiftlintのインストールをスキップ（Xcode.appが必要です）"

# for java
if [ -d "$(brew --prefix)/opt/openjdk/libexec/openjdk.jdk" ]; then
    sudo ln -sfn "$(brew --prefix)/opt/openjdk/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk
fi
# homebrew cask
# brew caskはなくなった。2021
#brew cask upgrade
# brew caskは途中でエラーあるとそこで止まるので、どうせ非同期してくれないのでarray()に入れてループで1つずつインストールする
array=(
    docker sublime-text macdown alfred dropbox karabiner-elements google-chrome
    firefox mysqlworkbench google-japanese-ime iterm2 charles clipy handbrake adobe-creative-cloud
    google-drive
#    google-backup-and-sync
#    gyazo
    notion
    notion-calendar
    chatwork
#    sharemouse
#    homebrew/cask-versions/sequel-pro-nightly
    sequel-ace
#    box-sync
    box-drive
    drawio
    zoom
    phpstorm
    alt-tab
    logi-options-plus
    # language-switcher  # ダウンロードできない？もう不要になった（OS標準で言語をアプリごとに変えれるようになった）
    # 任意
    # android-studio dnsmasq java
    # messenger  2025/12 アプリ版終了
    bartender
    claude-code
    onedrive  # App Store版は起動不可の事例があり、Microsoft公式pkg版に切替
)
for i in "${array[@]}"
do
    cask_info=$(brew info --cask "$i" 2>&1)
    if echo "$cask_info" | grep -q "^Installed"; then
        outdated=$(brew outdated --cask "$i" 2>/dev/null)
        if [ -n "$outdated" ]; then
            echo "↑ $i をアップデート中..."
            brew upgrade --cask "$i"
        else
            echo "✓ $i はインストール済み（最新）"
        fi
    else
        echo "→ $i をインストール中..."
        brew install --cask "$i"
    fi
done

# Gatekeeper隔離属性を削除
xattr -d com.apple.quarantine /Applications/MacDown.app 2>/dev/null

# ためしたい adobe-creative-cloud-cleaner-tool
# skitch evernote はapp store版で。
# 必須ではない
# brew cask install vagrant virtualbox

# cleanupはたまにやるようにしたい
#brew cleanup


######## mac homebrew ##################################################################

head "1.1. asdf"

# asdf plugin list all
# nodenv, rbenv, pyenv, と共存する。> .node-versionとかを見てくれないので

asdf plugin add golang
asdf plugin add nodejs


######## mas ##################################################################

head "2. mas = mac app store"

# mas = mac app store
# 5分でタイムアウト
echo "mas upgrade"
gtimeout --foreground 300 mas upgrade || echo "mas upgrade がタイムアウトまたはエラー"

echo "mas install"
declare -A mas_apps=(
    [302584613]="Kindle"
    [406056744]="Evernote"
    [408981434]="iMovie"
    [361285480]="Keynote"   # 旧ID 409183694 は廃止
    [361309726]="Pages"     # 旧ID 409201541 は廃止
    [361304891]="Numbers"   # 旧ID 409203825 は廃止
    [417375580]="BetterSnapTool"
    [425424353]="The Unarchiver"
    [425955336]="Skitch"
    [513610341]="Integrity"
    [539883307]="LINE"
    [592704001]="Photos Duplicate Cleaner"
    [803453959]="Slack"
    # 823766827 OneDrive はMicrosoft公式pkg版(brew cask onedrive)に切替済み
    [1295203466]="Windows App"
    [462058435]="Microsoft Excel"
    [462054704]="Microsoft Word"
    [462062816]="Microsoft PowerPoint"
    [937984704]="Amphetamine"
    [1429033973]="RunCat"
    [1168254295]="AmorphousDiskMark"
)
for adam_id in "${!mas_apps[@]}"; do
    app_name="${mas_apps[$adam_id]}"
    result=$(gtimeout 30 mas install "$adam_id" 2>&1)
    exit_code=$?
    if [ $exit_code -eq 124 ]; then
        echo "⚠ $app_name ($adam_id): タイムアウト"
    elif echo "$result" | grep -q "Already installed"; then
        echo "✓ $app_name はインストール済み"
    elif echo "$result" | grep -q "No apps found"; then
        echo "✗ $app_name ($adam_id): App Store で見つかりません"
    elif [ $exit_code -ne 0 ]; then
        echo "✗ $app_name ($adam_id): エラー - $result"
    else
        echo "✓ $app_name をインストールしました"
    fi
done

# なくなった
# 896934587 Soliton SecureBrowser Pro
# 405399194 Kindle Classic
# 409789998 Twitter (4.3.2)
# 562172072 SongTweeter (2.0)
# 715768417 Microsoft Remote Desktop (8.0.30030)
# 557168941 Tweetbot (2.5.8)
# 421131143 MPlayerX (1.0.14)
# 452695239 QREncoder (1.5)
# 504544917 Clear (1.1.7)
# 568494494 Pocket (1.8.1)
# 880001334 Reeder (3.2.1)

# 必須ではない
# 414030210 LimeChat (2.43)
# 482898991 LiveReload (2.3.81)
# 634148309 Logic Pro X (10.4.3)
# 682658836 GarageBand (10.3.2)

# 入れない
# 405843582 Alfred (1.2)  brew cask版が新しいので
# 497799835 Xcode 自分で管理

#    sudo xcodebuild -license

######## hostname mac ##################################################################

head "4. set hostname"

HOSTNAME=`scutil --get ComputerName`
echo "ComputerName: $HOSTNAME"
if [ "`scutil --get HostName`" != $HOSTNAME ]; then
    echo "HostName: `scutil --get HostName` -> $HOSTNAME"
    sudo scutil --set HostName "$HOSTNAME"
fi
if [ "`scutil --get LocalHostName`" != $HOSTNAME ]; then
    echo "LocalHostName: `scutil --get LocalHostName` -> $HOSTNAME"
    sudo scutil --set LocalHostName "$HOSTNAME"
fi


######## hostname mac ##################################################################

head "5. install font"

ICLOUD_FONTS=~/Library/Mobile\ Documents/com~apple~CloudDocs/Fonts

if [ ! -f ~/Library/Fonts/SourceCodePro-Regular-Powerline.otf ]; then
    if [ -f "$ICLOUD_FONTS/SourceCodePro-Regular-Powerline.otf" ]; then
        cp -n "$ICLOUD_FONTS/SourceCodePro-Regular-Powerline.otf" ~/Library/Fonts/
    else
        echo "フォントが見つかりません: $ICLOUD_FONTS/SourceCodePro-Regular-Powerline.otf"
    fi
fi
if [ -d "$ICLOUD_FONTS/Microsoft" ]; then
    cp -n "$ICLOUD_FONTS/Microsoft/"*.ttf ~/Library/Fonts/
else
    echo "フォントフォルダが見つかりません: $ICLOUD_FONTS/Microsoft"
fi
if [ -d "$ICLOUD_FONTS/kawaii手書き文字" ]; then
    cp -n "$ICLOUD_FONTS/kawaii手書き文字/"*.ttf ~/Library/Fonts/
else
    echo "フォントフォルダが見つかりません: $ICLOUD_FONTS/kawaii手書き文字"
fi


######## install picasa ##################################################################
# 廃盤なので、扱いが特殊

head "6. install picasa"

ONEDRIVE=~/Library/CloudStorage/OneDrive-Personal

if [ ! -d /Applications/Picasa.app/ ]; then
    if [ -e "$ONEDRIVE/【圧縮】/mac/picasamac39.dmg" ]; then
        open "$ONEDRIVE/【圧縮】/mac/picasamac39.dmg"
        open /Applications/Picasa.app
    else
        echo "Picasaインストーラが見つかりません: $ONEDRIVE/【圧縮】/mac/picasamac39.dmg"
    fi
fi


######## create local apps ##################################################################

head "7. create local apps"

# ResetCoreAudio はsudoが必要なのでAutomatorで管理
# (iCloud Drive: ~/Library/Mobile Documents/com~apple~Automator/Documents/ResetCoreAudio.app)

# 通知を一斉にクリアするアプリ（Alfred/Spotlightから呼び出す用）
# usernoted DBの未読(presented=0)を既読化し、delivered/displayedテーブルもクリア。
# usernoted稼働中はDBロックでUPDATE/DELETEに失敗するため先にkillし、
# DB操作後に再度killして起動時にDBを読み直させる必要がある。
KILL_NOTIFICATION_APP="$HOME/Applications/kill notification.app"
KILL_NOTIFICATION_SCRIPT='do shell script "killall usernoted NotificationCenter 2>/dev/null; sleep 0.5; sqlite3 ~/Library/Group\\ Containers/group.com.apple.usernoted/db2/db \"UPDATE record SET presented = 1 WHERE presented = 0 OR presented IS NULL; DELETE FROM delivered; DELETE FROM displayed;\"; killall usernoted NotificationCenter 2>/dev/null; true"'
KILL_NOTIFICATION_HASH=$(echo "$KILL_NOTIFICATION_SCRIPT" | md5)
KILL_NOTIFICATION_HASH_FILE="$HOME/Applications/kill notification.app.md5"
mkdir -p "$HOME/Applications"
if [ ! -d "$KILL_NOTIFICATION_APP" ] || [ "$(cat "$KILL_NOTIFICATION_HASH_FILE" 2>/dev/null)" != "$KILL_NOTIFICATION_HASH" ]; then
    osacompile -o "$KILL_NOTIFICATION_APP" -e "$KILL_NOTIFICATION_SCRIPT"
    echo "$KILL_NOTIFICATION_HASH" > "$KILL_NOTIFICATION_HASH_FILE"
    echo "作成/更新: $KILL_NOTIFICATION_APP"
else
    echo "✓ kill notification.app はインストール済み（最新）"
fi

# 外付けボリュームを一括イジェクトするアプリ（USB-C引き抜き前にAlfred等から起動）
EJECT_ALL_APP="$HOME/Applications/eject all.app"
EJECT_ALL_SCRIPT='set failedList to {}
set externalVolumes to paragraphs of (do shell script "ls /Volumes 2>/dev/null")
repeat with volName in externalVolumes
    set v to volName as string
    if v is not "" and v is not "Macintosh HD" then
        try
            do shell script "diskutil eject " & quoted form of ("/Volumes/" & v)
        on error
            set end of failedList to v
        end try
    end if
end repeat

if failedList is not {} then
    set AppleScript'"'"'s text item delimiters to ", "
    set msg to failedList as string
    set AppleScript'"'"'s text item delimiters to ""
    display notification msg with title "イジェクト失敗" subtitle "次のボリュームを取り外せませんでした"
end if'
EJECT_ALL_HASH=$(echo "$EJECT_ALL_SCRIPT" | md5)
EJECT_ALL_HASH_FILE="$HOME/Applications/eject all.app.md5"
if [ ! -d "$EJECT_ALL_APP" ] || [ "$(cat "$EJECT_ALL_HASH_FILE" 2>/dev/null)" != "$EJECT_ALL_HASH" ]; then
    osacompile -o "$EJECT_ALL_APP" -e "$EJECT_ALL_SCRIPT"
    echo "$EJECT_ALL_HASH" > "$EJECT_ALL_HASH_FILE"
    echo "作成/更新: $EJECT_ALL_APP"
else
    echo "✓ eject all.app はインストール済み（最新）"
fi


######## other tools ##################################################################

head "8. other tools"

# gemini cli, ccusage
npm install -g @google/gemini-cli
npm install -g ccusage


######## done ##################################################################


head "### Setup Mac Finished. ###"
