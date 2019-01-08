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
fi


# スクリプト等インストール yum apt homebrew
# ToDo


# mac homebrew
head "2. Homebrew"
if [ `uname` = "Darwin" ]; then
    if [ ! -x "`which brew 2>/dev/null`" ]; then
        # http://brew.sh/index_ja.html
        echo Install Homebrew.
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew doctor
# チャレンジしたい
#        brew cask install firefox vagrant virtualbox mysqlworkbench skitch evernote google-japanese-ime
    fi
    brew update
    brew upgrade
    brew install tmux gnu-sed mysql tig wget emacs git colordiff global peco imagemagick telnet jq npm
    brew cask install docker sublime-text macdown alfred dropbox karabiner-elements google-chrome
    # 途中karabiner-elementsでFumihiko Takayamaを許可するかどうか出てくるので許可を。
    # 初回は全部開いてダイアログでagreeを @todo; agreeないのだけにしたい
    open /Applications/Docker.app
    open /Applications/Sublime\ Text.app
    open /Applications/MacDown.app
    open /Applications/Alfred\ 3.app
    open /Applications/Dropbox.app
    open /Applications/Karabiner-Elements.app
    open /Applications/Google\ Chrome.app
fi


# mlocate for mac
head "3. symbolic links"
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
    head "4. cask install"
    cd ~/.emacs.d/ ; cask install ; cd -
fi


######## ssh config ##################################################################

head "5. ssh config"
mkdir -p -m 700 ~/.ssh
chmod 600 ~/.ssh/config


######## private ##################################################################

head "6. private setup"
if [ -f ~/private/scripts/setup_private.sh ]; then
    sh ~/private/scripts/setup_private.sh
fi


######## done ##################################################################

echo
echo "please 'source ~/.zshrc'"
echo
