#!/bin/sh

# zshをローカル環境にインストール
# 注意： bc, wget, gcc, ncurses6 が必要

# http://zsh.sourceforge.net/Arc/source.html で最新バージョンを確認、更新。

version=5.8

echo "Check latest version."
echo "> http://zsh.sourceforge.net/Arc/source.html"
echo
echo "$version : ok?"
echo
read

###########################################################

installed=`zsh --version 2>/dev/null | grep -o " [0-9]\+\.[0-9]\+\." | grep -o "[0-9]\+\.[0-9]\+"`

if [ $installed == $version ]; then
    echo already installed.
    exit
elif [ `echo "$installed > $version" | bc` == 1 ]; then
    echo "Version Error. $installed > $version"
    exit
fi

# ビルドに必要なものチェックしたいかも。gcc, ncurses-devel, とか。wgetも？

cd ~/tmp

if [ ! -e ~/tmp/zsh-$version.tar.xz ]; then
    wget http://sourceforge.net/projects/zsh/files/zsh/$version/zsh-$version.tar.xz
fi

tar xvf zsh-$version.tar.xz
cd zsh-$version
mkdir -p ~/opt
./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib"  --enable-multibyte --enable-locale --with-tcsetpgrp
make
make install
