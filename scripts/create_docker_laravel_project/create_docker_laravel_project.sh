#!/bin/bash

# 前提
# dockerが動いている
# docker-compose composer php npm

# laravel/sailは使わない＞なんか違った。でも参考にしたい。
# 選択によってはsocialite, debugbar強制。

# @todo;
# slack, mailhog, gtags, とか絶対使うの入れたい

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

# mysql port

port=`cat $script_dir/storage/latest_port_mysql 2>/dev/null`
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

# 認証パッケージ
# jetstream:livewire, jetstream:inertia(vuejs), ui(bootstrap), breeze(simple)

while :
do
    echo "Install Auth Package ..."
    echo
    echo "1: jetstream:livewire"
    echo "2: jetstream:inertia(vuejs)"
    echo "3: ui(bootstrap)"
    echo "4: breeze(simple)"
    echo "5: none"
    echo
    read -n1 -p "? : " -a install_auth
    echo
    if [[ "$install_auth" = [12345] ]]; then
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
echo Install Auth Package: $install_auth
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
mkdir -p storage/tmp/local-mysql/data

# 書き換え
find {docker*,Makefile} -type f -exec sed -i -e "s/PROJECT_NAME/${project}/g" {} \;
find {docker*,Makefile} -type f -exec sed -i -e "s/PHP_VERSION/${php_version}/g" {} \;
find {docker*,Makefile} -type f -exec sed -i -e "s/NGINX_PORT/${nginx_port}/g" {} \;
find {docker*,Makefile} -type f -exec sed -i -e "s/MYSQL_VERSION/${mysql_version}/g" {} \;
find {docker*,Makefile} -type f -exec sed -i -e "s/MYSQL_PORT/${mysql_port}/g" {} \;

git add -A
git commit -m "auto commit (install templates & docker)"


# setup
# APP_KEY
make install
make up
# mysql立ち上がるのを待つ
echo
echo waiting...
until docker-compose exec mysql sh -c "MYSQL_PWD=password mysqladmin ping --silent"; do
    sleep 2
    echo .
done
sleep 5
echo

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


# adminlte and socialite
if [[ $install_adminlte = "yes" ]]; then
    echo
    echo "Install AdminLTE"
    echo
    npm install admin-lte --save

    # socialite
    composer require laravel/socialite
    composer require socialiteproviders/facebook
    # app/Providers/EventServiceProvider.phpの更新も @todo;
    #// Socialite
    #\SocialiteProviders\Manager\SocialiteWasCalled::class => [
    #// facebook
    #'SocialiteProviders\\Facebook\\FacebookExtendSocialite@handle',
    #],
    #// routes/web.php も
    #// Social Login
    #Route::prefix('login/{provider}')->where(['provider' => '(facebook)'])->group(function(){
    #Route::get('/', 'App\Http\Controllers\Auth\LoginController@redirectToProvider')->name('social_login.redirect');
    #Route::get('/callback', 'App\Http\Controllers\Auth\LoginController@handleProviderCallback')->name('social_login.callback');
    #});

    # https://blog.capilano-fw.com/?p=7862

    HTTP_PORT=$nginx_port PROJECT_NAME=$project php $script_dir/install_adminlte.php

    npm install
    npm run dev

    git add -A
    git commit -m "auto commit (install admin-lte)"
fi

# install auth package
echo
echo "Install Auth Package"
echo
case "$install_auth" in
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
        install_auth_name="ui(bootstrap)"
        echo $install_auth_name
        composer require laravel/ui
        php artisan ui vue --auth
#        php artisan ui bootstrap --auth
#        php artisan ui react --auth
        ;;
    4)
        install_auth_name="breeze(simple)"
        echo $install_auth_name
        composer require laravel/breeze --dev
        php artisan breeze:install
        ;;
    5)
        install_auth_name="none"
        echo $install_auth_name
        ;;
esac

if [[ "$install_auth" = [1234] ]]; then
    npm install
    npm run dev
    git add -A
    git commit -m "auto commit (install auth) $install_auth_name"
fi

# migrate
make migrate


# ここでブランチ切っておく
master=`git branch --show-current`
git checkout -b first
git checkout $master


# gtags @todo;


# save latest port
echo $nginx_port > $script_dir/storage/latest_port_nginx
echo $mysql_port > $script_dir/storage/latest_port_mysql


echo
echo done.
echo
