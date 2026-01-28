#!/usr/bin/bash

if ! type 'apt-get' >/dev/null 2>&1 ;then
    # aptではない
    # macに意味不明なaptが入るようになったのでapt-getで判定する
    exit
fi

echo
read -n 1 -p "sudo apt install ... ok? (y/n) : " -a yn
echo

if [[ "$yn" != [yY] ]]; then
    exit
fi

# locale設定
sudo locale-gen en_US.UTF-8
sudo locale-gen ja_JP.UTF-8
sudo update-locale

sudo apt install -y make emacs zsh php php-mbstring tig

# 入れないもの
# language-pack-ja

loginshell=`grep $USER /etc/passwd | cut -d: -f7 | sed -e 's/^.*\///'`
if [ ! "$loginshell" = 'zsh' ]; then
    echo "shellをzshに変更"

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
fi
