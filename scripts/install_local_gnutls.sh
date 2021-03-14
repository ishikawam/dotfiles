#!/bin/sh

# emacsに必要なgnutlsをローカル環境にインストール
# wget, gcc が必要

# https://www.gnupg.org/ftp/gcrypt/gnutls/
# で最新バージョンを確認、更新。

version=3.7.1
version_major=3.7

echo "Check latest version."
echo "> https://www.gnupg.org/ftp/gcrypt/gnutls/"
echo
echo "$version : ok?"
echo
read

###########################################################

# ビルドに必要なものチェックしたいかも。gcc, ncurses-devel, とか。wgetも？

cd ~/tmp

if [ ! -e ~/tmp/gnutls-$version.tar.gz ]; then
    wget https://www.gnupg.org/ftp/gcrypt/gnutls/v$version_major/gnutls-$version.tar.xz
fi

tar xvf gnutls-$version.tar.xz
cd gnutls-$version
mkdir -p ~/opt
./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib" --enable-multibyte --enable-locale --with-tcsetpgrp
make
make install


# Libnettle
# nuttleが必要って怒られるかもしれない。
# https://ftp.gnu.org/gnu/nettle/nettle-3.6.tar.gz
# https://ftp.gnu.org/gnu/nettle/
# gmpじゃないとgnultsでエラーになるので
# ./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib" --enable-multibyte --enable-locale --with-tcsetpgrp --enable-mini-gmp
# gmpも有効じゃないとだめ。

# gmp
# https://gmplib.org/download/gmp/
# https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz
# ./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib" --enable-multibyte --enable-locale --with-tcsetpgrp

# そうすると、gnutlsのconfigureは
# PKG_CONFIG_PATH="$HOME/opt/lib64/pkgconfig" ./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib" --enable-multibyte --enable-locale --with-tcsetpgrp
# しないと。

# いや、gmpはずそう。。。無理だった。
# PKG_CONFIG_PATH="$HOME/opt/lib/pkgconfig:$HOME/opt/lib64/pkgconfig" ./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib" --enable-multibyte --enable-locale --with-tcsetpgrp --with-nettle-mini

# 今度は
# Libtasn1 4.9 was not found. To use the included one, use --with-included-libtasn1
# https://ftp.gnu.org/gnu/libtasn1/
# 面倒なので外す。
# PKG_CONFIG_PATH="$HOME/opt/lib/pkgconfig:$HOME/opt/lib64/pkgconfig" ./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib" --enable-multibyte --enable-locale --with-tcsetpgrp --with-nettle-mini --with-included-libtasn1

# 今度は
# Libunistring was not found. To use the included one, use --with-included-unistring
# PKG_CONFIG_PATH="$HOME/opt/lib/pkgconfig:$HOME/opt/lib64/pkgconfig" ./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib" --enable-multibyte --enable-locale --with-tcsetpgrp --with-nettle-mini --with-included-libtasn1 --with-included-unistring

# 今度は
# p11-kit >= 0.23.1 was not found. To disable PKCS #11 support
# use --without-p11-kit, otherwise you may get p11-kit from
# https://p11-glue.freedesktop.org/p11-kit.html
# だって。
# PKG_CONFIG_PATH="$HOME/opt/lib/pkgconfig:$HOME/opt/lib64/pkgconfig" ./configure --prefix=$HOME/opt --enable-cflags="-I$HOME/opt/include" --enable-cppflags="-I$HOME/opt/include" --enable-ldflags="-L$HOME/opt/lib" --enable-multibyte --enable-locale --with-tcsetpgrp --with-nettle-mini --with-included-libtasn1 --with-included-unistring --without-p11-kit

