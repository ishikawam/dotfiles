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
brew upgrade
brew upgrade --cask
brew install \
    tmux git tig git-lfs colordiff \
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
brew install swiftlint 2>/dev/null || echo "⚠️  swiftlintのインストールをスキップ（Xcode.appが必要です）"

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
)
brewcaskls=`brew list --cask 2>/dev/null`
for i in "${array[@]}"
do
    if echo "$brewcaskls" | grep -q "^$i$"; then
        echo "✓ $i はインストール済み"
    else
        echo "→ $i をインストール中..."
        brew install --cask $i
    fi
done
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
echo mas upgrade
mas upgrade

echo mas install
mas_apps=(
    302584613   # Kindle
    406056744   # Evernote (7.7)
    408981434   # iMovie (10.1.10)
    409183694   # Keynote (8.3)
    409201541   # Pages (7.3)
    409203825   # Numbers (5.3)
    417375580   # BetterSnapTool (1.9)
    425424353   # The Unarchiver (4.0.0)
    425955336   # Skitch (2.8.2)
    513610341   # Integrity (8.1.19)  QAリンクチェッカー
    539883307   # LINE (5.12.0)
    592704001   # Photos Duplicate Cleaner
    803453959   # Slack (3.3.3)
    823766827   # OneDrive (18.214.1021)
    1295203466  # Microsoft Remote Desktop (10.2.4)
    462058435   # Microsoft Excel
    462054704   # Microsoft Word
    462062816   # Microsoft PowerPoint
    937984704   # amphetamine
    1429033973  # RunCat (11.4)
    1168254295  # AmorphousDiskMark (4.0.1)
)
mas install "${mas_apps[@]}"

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
        echo "⚠️  フォントが見つかりません: $ICLOUD_FONTS/SourceCodePro-Regular-Powerline.otf"
    fi
fi
if [ -d "$ICLOUD_FONTS/Microsoft" ]; then
    cp -n "$ICLOUD_FONTS/Microsoft/"*.ttf ~/Library/Fonts/
else
    echo "⚠️  フォントフォルダが見つかりません: $ICLOUD_FONTS/Microsoft"
fi
if [ -d "$ICLOUD_FONTS/kawaii手書き文字" ]; then
    cp -n "$ICLOUD_FONTS/kawaii手書き文字/"*.ttf ~/Library/Fonts/
else
    echo "⚠️  フォントフォルダが見つかりません: $ICLOUD_FONTS/kawaii手書き文字"
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
        echo "⚠️  Picasaインストーラが見つかりません: $ONEDRIVE/【圧縮】/mac/picasamac39.dmg"
    fi
fi


######## other tools ##################################################################

head "7. other tools"

# claude code, gemini cli, ccusage
npm install -g @anthropic-ai/claude-code
npm install -g @google/gemini-cli
npm install -g ccusage


######## done ##################################################################


head "### Setup Mac Finished. ###"
