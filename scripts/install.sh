#!/bin/sh
# 前提：githubへ接続できる(git cloneできる)

if [ -d .git ]; then
    echo ".gitがすでに存在します" 1>&2
    exit
fi

if [ `pwd` != $HOME ]; then
    # install other
    echo "ここにdotfilesをインストールします"
    git clone git@github.com:ishikawam/dotfiles.git .
    git submodule update --init

    echo "ログインし直してmake setupを実行してください"

    exit
fi

# install home
echo "homeにdotfilesをインストールします"

git clone -n git@github.com:ishikawam/dotfiles.git
mv dotfiles/.git ./
rm -r dotfiles
git reset
git submodule update --init

# 既存ファイルと衝突した分(modified)を~/tmp/に退避する
mkdir ~/tmp/ ; git status | grep modified: | grep -o "[^ ]*$" | xargs -n 1 -I{} cp {} ~/tmp/

git checkout .
chmod 600 ~/.ssh/config

# submodule
if [ `uname` = "Darwin" ]; then
    if [ ! -d ~/Library/.git ]; then
        cd
        git clone git@github.com:ishikawam/library_dotfiles.git
        mv library_dotfiles/.git ~/Library/
        rm -rf library_dotfiles
        cd ~/Library/
        git reset
        git checkout .
        cd -
    fi
fi

# 既存ファイルと衝突した分(add)を~/tmp/に退避する
git status -sb | grep "^??" | grep -o "[^ ]*$" | xargs -n 1 -I{} mv {} ~/tmp/

# setup
sh ~/scripts/setup.sh

# updates
