#!/bin/bash

# 前提
# dockerが動いている
# docker-compose composer npm

echo

# 空のディレクトリかチェック
if [ -n "`ls -A`" ]; then
    echo "Please select an empty directory."
    exit
fi

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(readlink "$name" || true)"
  done

  pwd -P
  cd "$cwd"
}
current_dir="$(abs_dirname "$0")"
echo $current_dir

# プロジェクト名
dir=`pwd`
project=`basename ${dir}`
while :
do
    read -n1 -p "Is project name '${project}' ? (Y/n) : " -a yn
    echo
    if [[ "$yn" = [yY] || -z "$yn" ]]; then
        break
    elif [[ "$yn" = [nN] ]]; then
        project=""
        break
    fi
done

if [ -z "${project}" ]; then
    while :
    do
        read -p "Project name is : " -a project
        echo
        if [ -n "${project}" ]; then
            break
        fi
    done
fi

# PHP (php:fpm-alpine) version

echo "(loading...)"
# バージョン2階層でfpm-alpineのみ取得
tags=`curl -s https://registry.hub.docker.com/v1/repositories/php/tags | jq -r ".[].name" | grep "^[0-9]\+\.[0-9]\+\-fpm\-alpine$" | grep -o "^[0-9\.]\+" | sort`

# 最新バージョン
for latest in $tags
do :
done
php_version=$latest

while :
do
    read -p "PHP version is (default: '${php_version}') : " -a input
    echo
    # 存在を調べる
    for i in $tags
    do
        if [ -z $input ]; then
            break 2
        elif [[ $i = $input ]]; then
            php_version=$input
            break 2
        fi
    done
    # 見つからない
    echo "select: `echo $tags | sed -e 's/\s/, /g'`"
done

# MySQL version

mysql_version=8.0
echo "(loading...)"
# バージョン2階層のみ取得
tags=`curl -s https://registry.hub.docker.com/v1/repositories/mysql/tags | jq -r ".[].name" | grep  "^[0-9]\+\.[0-9]\+$" | sort`

# 最新バージョン
for latest in $tags
do :
done
mysql_version=$latest

while :
do
    read -p "MySQL version is (default: '${mysql_version}') : " -a input
    echo
    # 存在を調べる
    for i in $tags
    do
        if [ -z $input ]; then
            break 2
        elif [[ $i = $input ]]; then
            mysql_version=$input
            break 2
        fi
    done
    # 見つからない
    echo "select: `echo $tags | sed -e 's/\s/, /g'`"
done

# nginx port

port=`cat $current_dir/storage/latest_port_nginx 2>/dev/null`

if [ -z $port ]; then
    port=10080
else
    port=`expr $port + 1`
fi

while :
do
    read -p "nginx port is (default: $port) : " -a input
    echo
    if [ -z $input ]; then
        break
    elif [[ $input =~ ^[0-9]+$ ]]; then
        port=$input
        break
    fi
done
nginx_port=$port

# mysql port

port=`cat $current_dir/storage/latest_port_mysql 2>/dev/null`
if [ -z $port ]; then
    port=13306
else
    port=`expr $port + 1`
fi

while :
do
    read -p "MySQL port is (default: $port) : " -a input
    echo
    if [ -z $input ]; then
        break
    elif [[ $input =~ ^[0-9]+$ ]]; then
        port=$input
        break
    fi
done
mysql_port=$port

# admin-lte

while :
do
    read -n1 -p "Install AdminLTE ? (y/n) : " -a yn
    echo
    if [[ "$yn" = [yY] ]]; then
        install_adminlte="yes"
        break
    elif [[ "$yn" = [nN] ]]; then
        install_adminlte="no"
        break
    fi
done


# 最終確認

echo
echo "-----------------"
echo Project name: $project
echo php version: $php_version
echo MySQL version: $mysql_version
echo nginx port: $nginx_port
echo MySQL port: $mysql_port
echo Install AdminLTE: $install_adminlte
echo "-----------------"
echo

while :
do
    read -n1 -p "Create, OK? (y/n) : " -a yn
    echo
    if [[ "$yn" = [yY] ]]; then
        break
    elif [[ "$yn" = [nN] ]]; then
        echo
        echo bye.
        echo
        exit
    fi
done

echo


# create

# laravel
composer create-project laravel/laravel .
git init
git add -A
git commit -m "first commit (install laravel)"

# docker
cp -a $current_dir/templates/* ./
cp -a $current_dir/templates/.* ./
mkdir -p storage/tmp/local-mysql/data

# 書き換え
find {docker*,Makefile} -type f -exec sed -i -e "s/PROJECT_NAME/${project}/g" {} \;
find {docker*,Makefile} -type f -exec sed -i -e "s/PHP_VERSION/${php_version}/g" {} \;
find {docker*,Makefile} -type f -exec sed -i -e "s/NGINX_PORT/${nginx_port}/g" {} \;
find {docker*,Makefile} -type f -exec sed -i -e "s/MYSQL_VERSION/${mysql_version}/g" {} \;
find {docker*,Makefile} -type f -exec sed -i -e "s/MYSQL_PORT/${mysql_port}/g" {} \;

git add -A
git commit -m "second commit (install docker)"


# setup
# APP_KEY
make install


# others

# helper
npm install json
npm run json -o json-4 -I -f composer.json -e 'this.autoload.files=["app/Helper/helpers.php"]'

git add -A
git commit -m "second commit (install others)"


# adminlte and auth
if [[ $install_adminlte = "yes" ]]; then
    npm install admin-lte --save
    cp node_modules/admin-lte/index.html resources/views/index.blade.php
    sed -i -e "s/welcome/index/g" routes/web.php
    mkdir public/adminlte
    ln -s ../node_modules/admin-lte/ public/
    sed -i -e 's/"dist\//"\/admin-lte\/dist\//g' resources/views/index.blade.php
    sed -i -e 's/"plugins\//"\/admin-lte\/plugins\//g' resources/views/index.blade.php

    # vuejs & auth
    composer require laravel/ui
    docker-compose exec php php artisan ui vue --auth
    npm install
    npm run dev

    git add -A
    git commit -m "second commit (install admin-lte)"
fi


# ここでブランチ切っておく
master=`git branch --show-current`
git checkout -b first
git checkout $master


# gtags @todo;


# save latest port
echo $nginx_port > $current_dir/storage/latest_port_nginx
echo $mysql_port > $current_dir/storage/latest_port_mysql


echo
echo done.
echo
