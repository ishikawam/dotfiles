#/bin/sh

if [ -d ~/.git ]; then
    echo "Cannot install dotfiles..." 1>&2
    exit;
fi

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
