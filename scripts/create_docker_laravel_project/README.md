create_docker_laravel_project
=============================

* スキャフォルディング
* これがいったいなにをやっているのかが明確＆シンプルに
* 目指すのは、レンタルサーバで稼働するサービスの開発環境を一瞬で構築、かつawsまで拡張できる
  * 石川はlocal、さくらのレンタルサーバ、さくらのVPS、AWS。

## なにをやっているか

* docker
  * php-fpm
  * nginx
  * mysql
* laravel
* bootstrap
  * admin-lte

## やらないこと

* aws

## commit

1. install laravel
2. install templates & docker
3. install others
4. install admin-lte
  * socialite(facebook), jetstream, livewire
  * setup views

## このあとにやることは

* Githubへpush
  * master, first, develop
  * mysql
    * Sequel Ace
      * MySQL Workbench
      * Models > Create EER Model from Database
      * 必要なテーブルに絞る
* Swagger
  * composer require zircote/swagger-php
  * npm install swagger-ui --save-dev
  * https://www.zu-min.com/archives/1098
* memcached, CACHE_DRIVER
* queue
* サーバ環境構築とCIセットアップ
  * awsの場合はSSL (app/Providers/AppServiceProvider.php に forceScheme()とか)
  * awsはMakefileをしっかり
* Issue作成
  * @todo; 一覧
  * @todo; Github CLI？

## todo

* templatesにfacebookが入ってたりして、最小構成で作ったときがおかしい
* memcachedも選択肢に
* sqlite機能しない
* cliのみに対応。nginx外してcontroller, viewをリセットする選択肢も
* migrationにsocial_accountsを
* app/Exceptions/Handler.php 絶対書き換えるのでコメント入れておくとか
* laravel/slack-notification-channel と Exception通知
  * キューqueueも必須にしたい。supervisordも
* version_hash
* 外部からのPOST禁止 app/Http/Kernel.php
* https強制
  * このあたりはコメントアウトで入れておいて、@todo; 入れたい。
* flash message
* nodenv入れるべき
* webpack.mix.js
* test, dusk
* maintenance.html メンテナンス中ページと表示
* public/favicon.ico, public/image/apple-touch-icon.png
* package.json > imagemin, sass, jquery
* docs/infra.drawio, ER図
* docker/php/default.ini : php8ならopache JIT, とか。
* Middlewareとconfigは他の生きてるリポジトリのを大いに参考にする
* awsやりたいなあ
* .env.example を削除


## todo 検討

* app/Console/Command.php


やるぞ
nodenv
facebook選択
