#!/bin/sh

# zshをローカル環境にインストール
# bc, wget, gcc, ncurses6 が必要

# http://zsh.sourceforge.net/Arc/source.html で最新バージョンを確認、更新。
version=5.5

###########################################################

installed=`zsh --version 2>/dev/null | grep -o " [0-9]\+\.[0-9]\+\." | grep -o "[0-9]\+\.[0-9]\+"`

if [ $installed == $version ]; then
    echo already installed.
    exit
elif [ `echo "$installed > $version" | bc` == 1 ]; then
    echo ばーじょんおおきいのが入っている
    exit
fi

# ビルドに必要なものチェックしたいかも。gcc, ncurses-devel, とか。wgetも？

cd ~/tmp

if [ ! -e ~/tmp/zsh-$version.tar.gz ]; then
    wget http://sourceforge.net/projects/zsh/files/zsh/5.5/zsh-5.5.tar.gz
fi

tar zxvf zsh-$version.tar.gz
cd zsh-$version
mkdir -p ~/opt
./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib"  --enable-multibyte --enable-locale --with-tcsetpgrp
make
make install
