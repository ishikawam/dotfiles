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

* .env
  * なぜかうまくいってない @todo;
  * 本来はAPP_KEYのみなるはず。
* Githubへpush
  * master, first, develop
* Sequel Ace
* MySQL Workbench
  * Models > Create EER Model from Database
  * 必要なテーブルに絞る
* Swagger
  * composer require zircote/swagger-php
  * npm install swagger-ui --save-dev
  * https://www.zu-min.com/archives/1098
* サーバ環境構築とCIセットアップ
  * awsの場合はSSL (app/Providers/AppServiceProvider.php に forceScheme()とか)
* Issue作成
  * @todo; 一覧
  * @todo; Github CLI？

## todo

* Makefileは一部 CACHE_DRIVER=array でartisan, composer
* templatesにfacebookが入ってたりして、最小構成で作ったときがおかしい
* memcachedも選択肢に
* mysql外す選択肢も
* cliのみに対応。nginx外してcontroller, viewをリセットする選択肢も
* migrationにsocial_accountsを
* app/Exceptions/Handler.php 絶対書き換えるのでコメント入れておくとか
* laravel/slack-notification-channel と Exception通知
  * キューも必須にしたい。supervisordも
* version_hash
* 外部からのPOST禁止 app/Http/Kernel.php
* https強制
  * このあたりはコメントアウトで入れておいて、@todo; 入れたい。
* flash message
* nodenv入れるべき
