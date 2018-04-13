#!/bin/sh

# emacs25に必要なncurses6をローカル環境にインストール
# wget, gcc が必要

# http://ftp.gnu.org/pub/gnu/ncurses で最新バージョンを確認、更新。
version=6.1

###########################################################

# ビルドに必要なものチェックしたいかも。gcc, ncurses-devel, とか。wgetも？

cd ~/tmp

if [ ! -e ~/tmp/emacs-$version.tar.gz ]; then
    wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$version.tar.gz
fi

tar zxvf ncurses-$version.tar.gz
cd ncurses-$version
mkdir -p ~/opt
./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib" --enable-multibyte --enable-locale --with-tcsetpgrp
make
make install
