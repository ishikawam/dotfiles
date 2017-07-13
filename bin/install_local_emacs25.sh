#/bin/sh

cd ~/tmp
wget http://ftp.gnu.org/pub/gnu/emacs/emacs-25.2.tar.gz
tar zxvf emacs-25.2.tar.gz
cd emacs-25.2
LDFLAGS="-L$HOME/opt/lib" ./configure --prefix=$HOME/opt --without-x
make
make install

cd ~/.emacs.d
cask install
cd
