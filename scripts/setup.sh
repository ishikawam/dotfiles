#!/bin/sh

# dotfilesのセットアップの直後に実施
# http://ishikawam.github.com/dotfiles/
# 定期的に実行することでインストールツールをログ記録＞yum apt-get homebrew gem npm
# @todo; 自分じゃなくてcloneしても使えるようにしたい。それだとgit更新系を免除したい。
# @todo; なんどもやらなくていいsetupと、更新とは別にしたい
# @todo; caskはemacs24じゃないと、の判定がいる。

head () {
    printf "\n\e[32m$1\e[m\n"
}

######## setup ##################################################################

# シェルを設定
head "1. Setup shell"
if [ `uname` = "Darwin" ]; then
    loginshell=`dscl localhost -read Local/Default/Users/$USER UserShell | cut -d' ' -f2 | sed -e 's/^.*\///'`
else
    loginshell=`grep $USER /etc/passwd | cut -d: -f7 | sed -e 's/^.*\///'`
fi
# priority order
if [ ! $loginshell = 'zsh' ]; then
    if [ -f /bin/zsh ]; then
        chsh -s /bin/zsh
    elif [ -f /usr/bin/zsh ]; then
        chsh -s /usr/bin/zsh
    elif [ -f /usr/local/bin/zsh ]; then
        chsh -s /usr/local/bin/zsh
    else
        chsh -s `which zsh`
    fi

    echo $loginshell -> `which zsh`
else
    echo Do nothing.
fi


######## mac homebrew ##################################################################

head "2. Homebrew (mac)"
if [ `uname` = "Darwin" ]; then
    if [ ! -x "`which brew 2>/dev/null`" ]; then
        # http://brew.sh/index_ja.html
        echo Install Homebrew.
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew doctor
    fi
    brew update
    brew upgrade
    brew install tmux gnu-sed mysql tig wget emacs git colordiff global peco imagemagick telnet jq npm mas
    brew cask install docker sublime-text macdown alfred dropbox karabiner-elements google-chrome
    brew cask install firefox mysqlworkbench google-japanese-ime iterm2 charles clipy handbrake language-switcher
    # ためしたい adobe-creative-cloud adobe-creative-cloud-cleaner-tool

    # skitch evernote はapp store版で。

    # 必須ではない
    # brew cask install vagrant virtualbox

    # mas = mac app store
    mas install 405399194 406056744 408981434 409183694 409201541 409203825 417375580 421131143 425424353 425955336 452695239 497799835 504544917 513610341 539883307 557168941 568494494 803453959 823766827 880001334 1295203466
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
else
    echo Do nothing.
fi


######## hostname mac ##################################################################

head "3. hostname (mac)"
if [ `uname` = "Darwin" ]; then
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
else
    echo Do nothing.
fi


######## symbolic links ##################################################################

head "4. symbolic links"

# mlocate for mac
if [ -f /usr/libexec/locate.updatedb -a ! -f ~/this/bin/updatedb ]; then
    # エイリアスにしていないのは、sudoで使いたいから
    ln -s /usr/libexec/locate.updatedb ~/this/bin/updatedb
fi
chmod go+rx Desktop Documents Downloads Movies Music Pictures Dropbox Google\ Drive OneDrive 2>/dev/null

# pyenv
mkdir -p ~/.pyenv/plugins/
if [ -d ~/.pyenv-virtualenv -a ! -d ~/.pyenv/plugins/pyenv-virtualenv ]; then
    ln -s ~/.pyenv-virtualenv ~/.pyenv/plugins/pyenv-virtualenv
fi

# rbenv
mkdir -p ~/.rbenv/plugins/
if [ -d ~/.rbenv-plugins/ruby-build -a ! -d ~/.rbenv/plugins/ruby-build ]; then
    ln -s ~/.rbenv-plugins/ruby-build ~/.rbenv/plugins/ruby-build
fi

# emacs cask
if [ -x "`which cask 2>/dev/null`" ]; then
    # python2.6以上に依存＞cask
    # pyenv install 2.7.9
    head "5. cask install"
    cd ~/.emacs.d/ ; cask install ; cd -
fi


######## ssh config ##################################################################

head "6. ssh config"
mkdir -p -m 700 ~/.ssh
chmod 600 ~/.ssh/config


######## private ##################################################################

head "7. private setup"
if [ -f ~/private/scripts/setup_private.sh ]; then
    sh ~/private/scripts/setup_private.sh
fi


######## done ##################################################################

head "Finished."
echo
echo "please 'source ~/.zshrc'"
echo
