#!/bin/sh

head () {
    printf "\n\e[32m$1\e[m\n"
}

# mac only
if [ `uname` != "Darwin" ]; then
    echo Do nothing.
    exit
fi

head "### Setup Mac ###"

######## mac homebrew ##################################################################

head "1. homebrew"

if [ ! -x "`which brew 2>/dev/null`" ]; then
    # http://brew.sh/index_ja.html
    echo Install Homebrew.
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor
fi
brew update
brew upgrade
brew install tmux gnu-sed mysql tig wget emacs git colordiff global peco imagemagick telnet jq npm mas
brew install carthage git-lfs swiftlint ruby rbenv ruby-build
brew cask install docker sublime-text macdown alfred dropbox karabiner-elements google-chrome
brew cask install firefox mysqlworkbench google-japanese-ime iterm2 charles clipy handbrake language-switcher adobe-creative-cloud sequel-pro google-backup-and-sync
# ためしたい adobe-creative-cloud-cleaner-tool
# skitch evernote はapp store版で。
# 必須ではない
# brew cask install vagrant virtualbox
brew cleanup


######## mas ##################################################################

head "2. mas = mac app store"

# mas = mac app store
mas install 405399194 406056744 408981434 409183694 409201541 409203825 417375580 421131143 425424353 425955336 452695239 497799835 504544917 513610341 539883307 557168941 568494494 592704001 803453959 823766827 880001334 1295203466
# 405399194 Kindle
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
# 497799835 Xcode (10.1)
# 504544917 Clear (1.1.7)
# 513610341 Integrity (8.1.19)  QAリンクチェッカー
# 539883307 LINE (5.12.0)
# 557168941 Tweetbot (2.5.8)
# 568494494 Pocket (1.8.1)
# 592704001 Photos Duplicate Cleaner
# 803453959 Slack (3.3.3)
# 823766827 OneDrive (18.214.1021)
# 880001334 Reeder (3.2.1)
# 1295203466 Microsoft Remote Desktop (10.2.4)

# なくなった
# 409789998 Twitter (4.3.2)
# 562172072 SongTweeter (2.0)
# 715768417 Microsoft Remote Desktop (8.0.30030)

# 必須ではない
# 414030210 LimeChat (2.43)
# 482898991 LiveReload (2.3.81)
# 634148309 Logic Pro X (10.4.3)
# 682658836 GarageBand (10.3.2)

# 入れない
# 405843582 Alfred (1.2)  brew cask版が新しいので

#    sudo xcodebuild -license

# chrome backup setting
# この.gitignoreはgit addできない。 > ここでgit initするから
cd ~/Library/Application\ Support/Google/Chrome/Default/
ln -sf ~/common/Chrome/Default/gitignore ./.gitignore
git init
cd -


######## hostname mac ##################################################################

head "3. set hostname"

HOSTNAME=`scutil --get ComputerName`
echo "ComputerName: $HOSTNAME"
if [ `scutil --get HostName` != $HOSTNAME ]; then
    echo "HostName: `scutil --get HostName` -> $HOSTNAME"
    sudo scutil --set HostName "$HOSTNAME"
fi
if [ `scutil --get LocalHostName` != $HOSTNAME ]; then
    echo "LocalHostName: `scutil --get LocalHostName` -> $HOSTNAME"
    sudo scutil --set LocalHostName "$HOSTNAME"
fi


######## hostname mac ##################################################################

head "4. install font"
if [ ! -f ~/Library/Fonts/SourceCodePro-Regular-Powerline.otf -a -f ~/Dropbox/Fonts/SourceCodePro-Regular-Powerline.otf ]; then
    cp -n ~/Dropbox/Fonts/SourceCodePro-Regular-Powerline.otf ~/Library/Fonts/
fi
if [ -d ~/Dropbox/Fonts/Microsoft ]; then
    cp -n ~/Dropbox/Fonts/Microsoft/*.ttf ~/Library/Fonts/
fi
if [ -d ~/Dropbox/Fonts/kawaii手書き文字 ]; then
    cp -n ~/Dropbox/Fonts/kawaii手書き文字/*.ttf ~/Library/Fonts/
fi


######## done ##################################################################

head "### Setup Mac Finished. ###"
