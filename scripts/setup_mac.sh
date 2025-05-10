#!/bin/bash

head () {
    printf "\n\e[32m$1\e[m\n"
}

# mac only
if [ "`uname`" != "Darwin" ]; then
    echo "Do nothing."
    exit
fi

hostname=`hostname`

if [[ $hostname =~ ^ishikawa- || -e ~/this/.force-defaults ]]; then
    # 自分の所有、か、~/this/.force-defaults があったら実行。
    echo
else
    echo "exit."
    exit
fi

head "### Setup Mac ###"

######## mac xcode ##################################################################

head "0. xcode"

if [ ! "$SSH_CLIENT" ]; then
    # mac端末上なら実行
    # @todo; caskも？masは？
    xcode-select --install 2>/dev/null
fi

######## mac homebrew ##################################################################

head "1. homebrew"

if ! type brew >/dev/null ; then
    # http://brew.sh/index_ja.html
    echo Install Homebrew.
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo re-run this.
    exit
fi
brew doctor
brew update
brew upgrade
brew install tmux gnu-sed mysql-client@8.4 tig wget emacs git colordiff global peco imagemagick telnet jq npm mas carthage git-lfs swiftlint ruby rbenv ruby-build awscli amazon-ecs-cli tree trash coreutils direnv composer java nodenv google-cloud-sdk asdf goenv
# for java
sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
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
    messenger
    bartender
)
brewcaskls=`brew ls`
#brewcaskls=`brew cask ls`
for i in "${array[@]}"
do
    if ! echo "$brewcaskls" | grep -o "\b$i\b"; then
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

asdf plugin add golang nodejs



######## mas ##################################################################

head "2. mas = mac app store"

# mas = mac app store
echo mas upgrade
timeout 300 mas upgrade

echo mas install
mas install 302584613 406056744 408981434 409183694 409201541 409203825 417375580 421131143 425424353 425955336 452695239 504544917 513610341 539883307 568494494 592704001 803453959 823766827 880001334 1295203466 462058435 462054704 462062816 937984704 1429033973 1168254295
# 302584613 Kindle
# 406056744 Evernote (7.7)
# 408981434 iMovie (10.1.10)
# 409183694 Keynote (8.3)
# 409201541 Pages (7.3)
# 409203825 Numbers (5.3)
# 417375580 BetterSnapTool (1.9)
# 421131143 MPlayerX (1.0.14)
# 425424353 The Unarchiver (4.0.0)
# 425955336 Skitch (2.8.2)
# 452695239 QREncoder (1.5)
# 504544917 Clear (1.1.7)
# 513610341 Integrity (8.1.19)  QAリンクチェッカー
# 539883307 LINE (5.12.0)
# 568494494 Pocket (1.8.1)
# 592704001 Photos Duplicate Cleaner
# 803453959 Slack (3.3.3)
# 823766827 OneDrive (18.214.1021)
# 880001334 Reeder (3.2.1)
# 1295203466 Microsoft Remote Desktop (10.2.4)
# 462058435 Microsoft Excel
# 462054704 Microsoft Word
# 462062816 Microsoft PowerPoint
# 937984704 amphetamine
# 1429033973  RunCat                    (11.4)
# 1168254295  AmorphousDiskMark  (4.0.1)

# なくなった
# 896934587 Soliton SecureBrowser Pro
# 405399194 Kindle Classic
# 409789998 Twitter (4.3.2)
# 562172072 SongTweeter (2.0)
# 715768417 Microsoft Remote Desktop (8.0.30030)
# 557168941 Tweetbot (2.5.8)

# 必須ではない
# 414030210 LimeChat (2.43)
# 482898991 LiveReload (2.3.81)
# 634148309 Logic Pro X (10.4.3)
# 682658836 GarageBand (10.3.2)

# 入れない
# 405843582 Alfred (1.2)  brew cask版が新しいので
# 497799835 Xcode 自分で管理

#    sudo xcodebuild -license

# xcode
# @todo; もっと早く入れたい
if [ ! -e /Applications/Xcode* ]; then
    mas install 497799835
fi

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

if [ ! -f ~/Library/Fonts/SourceCodePro-Regular-Powerline.otf -a -f ~/Dropbox/Fonts/SourceCodePro-Regular-Powerline.otf ]; then
    cp -n ~/Dropbox/Fonts/SourceCodePro-Regular-Powerline.otf ~/Library/Fonts/
fi
if [ -d ~/Dropbox/Fonts/Microsoft ]; then
    cp -n ~/Dropbox/Fonts/Microsoft/*.ttf ~/Library/Fonts/
fi
if [ -d ~/Dropbox/Fonts/kawaii手書き文字 ]; then
    cp -n ~/Dropbox/Fonts/kawaii手書き文字/*.ttf ~/Library/Fonts/
fi


######## install picasa ##################################################################
# 廃盤なので、扱いが特殊

head "6. install picasa"

if [ ! -d /Applications/Picasa.app/ -a -e ~/Dropbox/【圧縮】/mac/picasamac39.dmg ]; then
    open ~/Dropbox/【圧縮】/mac/picasamac39.dmg
    open /Applications/Picasa.app
fi


######## done ##################################################################

head "### Setup Mac Finished. ###"
