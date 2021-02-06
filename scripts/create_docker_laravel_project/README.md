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

## commit

1. install laravel
2. install templates & docker
3. install others
4. install admin-lte
  * socialite(facebook), jetstream, livewire
  * setup views

> admin-lteのセットアップに他の色々も混ざっているのでリファクタしないと @todo;
