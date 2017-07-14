#/bin/sh

cd
cp .bashrc .bashrc_
git clone -n git@github.com:ishikawam/dotfiles.git
mv dotfiles/.git ./
git reset
git checkout .
rm -rf dotfiles
git submodule update --init
sh ~/scripts/setup.sh

# updates
