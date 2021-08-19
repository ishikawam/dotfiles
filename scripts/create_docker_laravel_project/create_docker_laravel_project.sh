#!/bin/bash

# 前提
# dockerが動いている
# docker-compose composer php npm gsed

# laravel/sailは使わない＞なんか違った。でも参考にしたい。
# 選択によってはsocialite, debugbar強制。

# @todo;
# slack, mailhog, gtags, とか絶対使うの入れたい
# slack:
# php artisan make:notification Slack
# composer require laravel/slack-notification-channel


echo

# docker起動確認
docker ps 1>/dev/null
if [ $? != 0 ]; then
    echo "Please run docker app."
    exit;
fi

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
script_dir="$(abs_dirname "$0")"
echo $script_dir

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

echo "(loading versions...)"
# バージョン2階層でfpm-alpineのみ取得
tags=`curl -s https://registry.hub.docker.com/v1/repositories/php/tags | jq -r ".[].name" | grep "^[0-9]\+\.[0-9]\+\-fpm\-alpine$" | grep -o "^[0-9\.]\+" | sort`
echo $tags

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
    echo "select: `echo $tags | gsed -e 's/\s/, /g'`"
done

# Database
# mysql, postgres, sqlite

while :
do
    echo "Install Database ..."
    echo
    echo "1: MySQL"
    echo "2: PostgreSQL"
    echo "3: SQLite or none"
    echo
    read -n1 -p "? : " -a install_database
    echo
    if [[ "$install_database" = [123] ]]; then
        break
    fi
done

# database versions
# database_name: laravelで使われている名前 pgsql
# database_image: docker imageで使われている名前 postgres
# どちらも関係ない場合はpostgresを使いたいのでdatabase_imageを使う

case "$install_database" in
    1)
        database_name=mysql
        database_image=mysql
        database_internal_port=3306
        database_dir=/var/lib/mysql
        echo "(loading versions...)"
        # バージョン2階層のみ取得
        tags=`curl -s https://registry.hub.docker.com/v1/repositories/mysql/tags | jq -r ".[].name" | grep  "^[0-9]\+\.[0-9]\+$" | sort`
        ;;
    2)
        database_name=pgsql
        database_image=postgres
        database_internal_port=5432
        database_dir=/var/lib/postgresql/data
        echo "(loading versions...)"
        tags=`curl -s https://registry.hub.docker.com/v1/repositories/postgres/tags | jq -r ".[].name" | grep "^[0-9]\+-alpine$" | sort -n`
        ;;
    3)
        database_name=""
        database_image=""
        database_internal_port=""
        database_dir=""
        tags=()
        ;;
esac

if [ "$tags" ]; then
    echo $tags

    # 最新バージョン
    for latest in $tags
    do :
    done
    database_version=$latest

    while :
    do
        read -p "Database version is (default: '${database_version}') : " -a input
        echo
        # 存在を調べる
        for i in $tags
        do
            if [ -z $input ]; then
                break 2
            elif [[ $i = $input ]]; then
                database_version=$input
                break 2
            fi
        done
        # 見つからない
        echo "select: `echo $tags | sed -e 's/\s/, /g'`"
    done

    # database port

    port=`cat $script_dir/storage/latest_port_database 2>/dev/null`
    if [ -z $port ]; then
        port=13306
    else
        port=`expr $port + 1`
    fi

    while :
    do
        read -p "Database port is (default: $port) : " -a input
        echo
        if [ -z $input ]; then
            break
        elif [[ $input =~ ^[0-9]+$ ]]; then
            port=$input
            break
        fi
    done
    database_port=$port
fi

# nginx port

port=`cat $script_dir/storage/latest_port_nginx 2>/dev/null`

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

# 認証パッケージ
# jetstream:livewire, jetstream:inertia(vuejs), ui(bootstrap), breeze(simple)

while :
do
    echo "Install Auth Package ..."
    echo
    echo "1: jetstream:livewire"
    echo "2: jetstream:inertia(vuejs)"
    echo "3: breeze(simple)"
    echo "4: ui(vuejs)"
    echo "5: ui(bootstrap)"
    echo "6: ui(react)"
    echo "0: none"
    echo
    read -n1 -p "? : " -a install_auth
    echo
    if [[ "$install_auth" = [0123456] ]]; then
        break
    fi
done

# admin-lte

while :
do
    read -n1 -p "Install AdminLTE & Socialite ? (y/n) : " -a yn
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
echo "Project name: $project"
echo "php version: $php_version"
echo "Database: $database_name"
echo "Database image: $database_image"
echo "Database version: $database_version"
echo "Database port: $database_port"
echo "Database dir: $database_dir"
echo "Database internal port: $database_internal_port"
echo "nginx port: $nginx_port"
echo "Install Auth Package: $install_auth"
echo "Install AdminLTE & Socialite: $install_adminlte"
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
\cp -a $script_dir/templates/* ./
\cp -a $script_dir/templates/.[a-z]* ./
mkdir -p storage/tmp/local-${database_image}/data

# 書き換え
find {docker*,Makefile,README.md} -type f -exec gsed -i -e "s/PROJECT_NAME/${project}/g" {} \;
find {docker*,Makefile} -type f -exec gsed -i -e "s/PHP_VERSION/${php_version}/g" {} \;
find {docker*,Makefile} -type f -exec gsed -i -e "s/NGINX_PORT/${nginx_port}/g" {} \;
find {docker*,Makefile} -type f -exec gsed -i -e "s/DATABASE_NAME/${database_name}/g" {} \;
find {docker*,Makefile} -type f -exec gsed -i -e "s/DATABASE_IMAGE/${database_image}/g" {} \;
find {docker*,Makefile} -type f -exec gsed -i -e "s/DATABASE_VERSION/${database_version}/g" {} \;
find {docker*,Makefile} -type f -exec gsed -i -e "s/DATABASE_PORT/${database_port}/g" {} \;
find {docker*,Makefile} -type f -exec gsed -i -e "s/DATABASE_INTERNAL_PORT/${database_internal_port}/g" {} \;
find {docker*,Makefile} -type f -exec gsed -i -e "s|DATABASE_DIR|${database_dir}|g" {} \;

# 差し替え database
case "$install_database" in
    1)
        \mv docker/php/Dockerfile-mysql docker/php/Dockerfile
        rm -rf docker/php/Dockerfile-*
        rm -rf docker/postgres
        ;;
    2)
        \mv docker/php/Dockerfile-postgres docker/php/Dockerfile
        rm -rf docker/php/Dockerfile-*
        rm -rf docker/mysql
        ;;
    3)
        rm -rf docker/mysql
        rm -rf docker/postgres
        ;;
esac

git add -A
git commit -m "auto commit (install templates & docker)"


# setup
# APP_KEY
make install
make up
case "$install_database" in
    1)
        # mysql立ち上がるのを待つ
        echo
        echo waiting...
        until docker-compose exec mysql sh -c "MYSQL_PWD=password mysqladmin ping --silent"; do
            sleep 2
            echo .
        done
        sleep 5
        echo
        ;;
    2)
        ;;
    3)
        ;;
esac


# others

# helper
npm install json
`npm bin`/json -o json-4 -I -f composer.json -e 'this.autoload.files=["app/Helper/helpers.php"]'

# php-cs-fixer
composer require --dev friendsofphp/php-cs-fixer

# debugbar
composer require --dev barryvdh/laravel-debugbar
php artisan vendor:publish --provider="Barryvdh\Debugbar\ServiceProvider"

# migration カラム変更 メモリ喰うので対応 `PHP Fatal error:  Allowed memory size of 1610612736 bytes exhausted (tried to allocate 4096 bytes)`
COMPOSER_MEMORY_LIMIT=-1 composer require doctrine/dbal

# 日本語化
curl https://readouble.com/laravel/8.x/ja/install-ja-lang-files.php | php


git add -A
git commit -m "auto commit (install others)"


# settings 書き換え
DATABASE_NAME=$database_name PROJECT_NAME=$project php $script_dir/settings.php
git add -A
git commit -m "auto commit (settings)"

# install auth package
echo
echo "Install Auth Package"
echo
case "$install_auth" in
    0)
        install_auth_name="none"
        echo $install_auth_name
        ;;
    1)
        install_auth_name="jetstream:livewire"
        echo $install_auth_name
        composer require laravel/jetstream
        php artisan jetstream:install livewire
        # jetstreamのviewsファイルをコピー。これも選択式のほうが良いかも？でもAdminLTEなら必須かと。
        php artisan vendor:publish --tag=jetstream-views
        ;;
    2)
        install_auth_name="jetstream:inertia(vuejs)"
        echo $install_auth_name
        composer require laravel/jetstream
        php artisan jetstream:install inertia
        ;;
    3)
        install_auth_name="breeze(simple)"
        echo $install_auth_name
        composer require laravel/breeze --dev
        php artisan breeze:install
        ;;
    4)
        install_auth_name="ui(vuejs)"
        echo $install_auth_name
        composer require laravel/ui
        php artisan ui vue --auth
        ;;
    5)
        install_auth_name="ui(bootstrap)"
        echo $install_auth_name
        composer require laravel/ui
        php artisan ui bootstrap --auth
        ;;
    6)
        install_auth_name="ui(react)"
        echo $install_auth_name
        composer require laravel/ui
        php artisan ui react --auth
        ;;
esac

if [ "$install_auth" != 0 ]; then
    npm install
    npm run dev
    git add -A
    git commit -m "auto commit (install auth) $install_auth_name"
fi


# adminlte & socialite
if [[ $install_adminlte = "yes" ]]; then
    echo
    echo "Install AdminLTE & Socialite"
    echo

    # socialite
    composer require laravel/socialite
    composer require socialiteproviders/facebook

    # socialite 設定
    HTTP_PORT=$nginx_port php $script_dir/configure_socialite.php

    # AdminLTE
    npm install admin-lte --save

    # index.blade.php
    php $script_dir/convert_html_to_blade.php 'node_modules/admin-lte/index.html' 'resources/views/admin/index.blade.php'

    # v2よりv1のほうがいいかも
    # cp resources/views/auth/login.blade.php resources/views/auth/login_.blade.php
    # php ~/scripts/create_docker_laravel_project/convert_html_to_blade.php node_modules/admin-lte/pages/examples/login.html resources/views/auth/login.blade.php
    # cp resources/views/auth/forgot-password.blade.php resources/views/auth/forgot-password_.blade.php
    # php ~/scripts/create_docker_laravel_project/convert_html_to_blade.php node_modules/admin-lte/pages/examples/forgot-password.html resources/views/auth/forgot-password.blade.php
    # cp resources/views/auth/register.blade.php resources/views/auth/register_.blade.php
    # php ~/scripts/create_docker_laravel_project/convert_html_to_blade.php node_modules/admin-lte/pages/examples/register.html resources/views/auth/register.blade.php
    # やっぱloginだけで、、Facebookしか使わないので

    # routes
    echo "
Route::get('/admin', function () {
    return view('admin/index');
});" >> routes/web.php

    #  public
    ln -s ../node_modules/admin-lte/ public/

    npm install
    npm run dev

    git add -A
    git commit -m "auto commit (install admin-lte & socialite)"
fi


# migrate
make migrate


# ここでブランチ切っておく
master=`git branch --show-current`
git checkout -b first
git checkout $master


# gtags
gtags -v 2>/dev/null


# save latest port
echo $nginx_port > $script_dir/storage/latest_port_nginx
echo $database_port > $script_dir/storage/latest_port_database


echo
echo done.
echo
