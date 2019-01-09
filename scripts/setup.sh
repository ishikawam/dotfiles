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
    brew cask install firefox mysqlworkbench google-japanese-ime iterm2
    # skitch evernote はapp storeかな
# チャレンジしたい
#        brew cask install vagrant virtualbox
    # 途中karabiner-elementsでFumihiko Takayamaを許可するかどうか出てくるので許可を。
    # 全部開いてダイアログでagreeを @todo; agreeないのだけにしたい
    open /Applications/Docker.app
#    open /Applications/Sublime\ Text.app
#    open /Applications/MacDown.app
    open /Applications/Alfred\ 3.app
    open /Applications/Dropbox.app
    open /Applications/Karabiner-Elements.app
#    open /Applications/Google\ Chrome.app
#    open /Applications/Firefox.app
#    open /Applications/MySQLWorkbench.app
#    open /Applications/Skitch.app
#    open /Applications/Evernote.app
else
    echo Do nothing.
fi


######## hostname mac ##################################################################

head "3. hostname (mac)"
if [ `uname` = "Darwin" ]; then
    HOSTNAME=`scutil --get ComputerName`
    echo "ComputerName: $HOSTNAME"
    echo "HostName: `scutil --get HostName` -> $HOSTNAME"
    sudo scutil --set HostName "$HOSTNAME"
    echo "LocalHostName: `scutil --get LocalHostName` -> $HOSTNAME"
    sudo scutil --set LocalHostName "$HOSTNAME"
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
