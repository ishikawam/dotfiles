#!/bin/sh

# emacsをローカル環境にインストール

# http://ftp.gnu.org/pub/gnu/emacs/ で最新バージョンを確認、更新。
version=25.2

###########################################################

installed=`emacs --version 2>/dev/null | grep -o " [0-9]\+\.[0-9]\+\." | grep -o "[0-9]\+\.[0-9]\+"`

if [ $installed == $version ]; then
    echo already installed.
    exit
elif [ `echo "$installed > $version" | bc` == 1 ]; then
    echo ばーじょんおおきいnoga
    exit
fi

# ビルドに必要なものチェックしたいかも。gcc, ncurses-devel, とか。wgetも？

cd ~/tmp

if [ ! -e ~/tmp/emacs-$version.tar.gz ]; then
    wget http://ftp.gnu.org/pub/gnu/emacs/emacs-$version.tar.gz
fi

tar zxvf emacs-$version.tar.gz
cd emacs-$version
LDFLAGS="-L$HOME/opt/lib" ./configure --prefix=$HOME/opt --without-x
make
make install

cd ~/.emacs.d
alias emacs=~/opt/lib/emacs ; cask install
cd
