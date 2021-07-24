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

head "### Setup ###"

######## setup shell ##################################################################

head "1. shell to zsh"

if [ "`uname`" = "Darwin" ]; then
    loginshell=`dscl localhost -read Local/Default/Users/$USER UserShell | cut -d' ' -f2 | sed -e 's/^.*\///'`
else
    loginshell=`grep $USER /etc/passwd | cut -d: -f7 | sed -e 's/^.*\///'`
fi
# priority order
if [ ! "$loginshell" = 'zsh' ]; then
    echo "shellを変更したい場合のみ返事してください"

    if [ -f /bin/zsh ]; then
        chsh -s /bin/zsh
    elif [ -f /usr/bin/zsh ]; then
        chsh -s /usr/bin/zsh
    elif [ -f /usr/local/bin/zsh ]; then
        chsh -s /usr/local/bin/zsh
    else
        chsh -s `which zsh`
    fi

    echo "$loginshell -> `which zsh`"
else
    echo "Do nothing."
fi


######## symbolic links ##################################################################

head "2. symbolic links"

# mlocate for mac
if [ -f /usr/libexec/locate.updatedb -a ! -f ~/this/bin/updatedb ]; then
    # エイリアスにしていないのは、sudoで使いたいから
    echo "set updatedb"
    ln -s /usr/libexec/locate.updatedb ~/this/bin/updatedb
fi
# locateしたいため権限を緩める
cd ~ ; chmod go+rx Desktop Documents Downloads Movies Music Pictures Dropbox Google\ Drive OneDrive 2>/dev/null ; cd -

# pyenv
mkdir -p ~/.pyenv/plugins/
if [ -d ~/.pyenv-virtualenv -a ! -d ~/.pyenv/plugins/pyenv-virtualenv ]; then
    echo "set virtualenv to pyenv"
    ln -s ~/.pyenv-virtualenv ~/.pyenv/plugins/pyenv-virtualenv
fi

# rbenv
mkdir -p ~/.rbenv/plugins/
if [ -d ~/.rbenv-plugins/ruby-build -a ! -d ~/.rbenv/plugins/ruby-build ]; then
    echo "set ruby-build to rbenv"
    ln -s ~/.rbenv-plugins/ruby-build ~/.rbenv/plugins/ruby-build
fi


######## emacs cask ##################################################################

head "3. cask install"

# emacs cask
# python2.6以上に依存＞cask
# pyenv install 2.7.9
if [ "`cask --version 2>/dev/null`" ]; then
    # emacsのメジャーバージョンを調べる
    EMACS_VERSION=`emacs --version | grep -o '^GNU Emacs [0-9]\+' | grep -o '[0-9]\+'`
    echo "Emacs $EMACS_VERSION."
    if [ $EMACS_VERSION != 26 ]; then
        # emacs 26ではcask使わない
        cd ~/.emacs.d/ ; cask install ; cd -
    else
        echo Do nothing.
    fi
else
    echo "No cask."
fi


######## ssh config ##################################################################

head "4. ssh config"

mkdir -p -m 700 ~/.ssh
if  [ ! -e ~/.ssh/config ]; then
    cd ~/.ssh/
    chmod 600 ../common/.ssh/config
    ln -s ../common/.ssh/config ./
    chmod 600 ./config
    cd -
fi

# warning
# @todo PasswordAuthentication no も強制するか検討。
# AllowUsers m_ishikawaを免除できるようにもしたい
# その上で、停止するなどしてAlertしたい
if [ ! "`grep 'AllowUsers m_ishikawa' /etc/ssh/sshd_config`" ]; then
    echo "!!!warning!!! 'AllowUsers m_ishikawa' not yet set."
fi


######## done ##################################################################

head "### Setup Finished. ###"

echo
echo "please 'source ~/.zshrc'"
echo
