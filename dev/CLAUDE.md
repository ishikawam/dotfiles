# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

macOS、Fedora、CentOS、Debian、Ubuntuに対応した個人用dotfiles。zshを前提としている。

## 主要コマンド

```bash
# 初回セットアップ（Mac環境）
make setup

# 全リポジトリを更新
make updates

# 全リポジトリをfetch
make fetch

# 全リポジトリをpull rebase
make pr

# キャッシュクリーンアップ
make clean

# ディスク使用状況確認
make disk-usage

# $PATHを見やすく表示
make path
```

## インストール方法

```bash
# ホームディレクトリへのインストール
curl -fsSL https://raw.githubusercontent.com/ishikawam/dotfiles/master/scripts/install.sh | sh

# sudoなし共用サーバへの設置
mkdir -p ~/home && cd ~/home
git clone git@github.com:ishikawam/dotfiles.git masayuki-ishikawa
cd masayuki-ishikawa && git submodule update && git submodule deinit private
env HOME=$HOME/home/masayuki-ishikawa zsh
```

## ディレクトリ構成

- `bin/` - 共通コマンド（PATH: ~/bin）
- `private/bin/` - 秘密コマンド（submodule）
- `this/bin/` - リポジトリ管理しない個別コマンド
- `scripts/` - セットアップスクリプト
- `common/.shrc` - bash/zsh共通シェル設定
- `.emacs.d/` - Emacs設定
- `.config/` - アプリケーション設定（gh、git、karabiner）
- `tmux-powerline/` - tmux-powerlineテーマ

## シェル設定の階層

1. `.zshrc` / `.bashrc` - シェル固有設定
2. `common/.shrc` - 共通設定（PATH、エイリアス、言語設定等）
3. `private/.shrc` - プライベート設定（submodule）
4. `this/.shrc` - ホスト固有設定

## バージョン管理ツール

- Node.js: nodenv優先（nodebrew、nvmより優先）
- Ruby: rbenv
- Python: pyenv
- Go: goenv、asdf

## フラグファイル

- `~/this/.force-defaults` - make defaultsとsetup_mac.shを実行するフラグ
- `~/this/.ignore-sparse` - private/installedtoolsを全て含めるモード
- `~/this/.eucjp` - EUC-JP環境フラグ

## make defaults

macOSのシステム設定やアプリ設定を自動適用する機能。

### 仕組み

- `scripts/defaults/defaults.php` - `defaults`コマンドと`PlistBuddy`で設定を適用
- `scripts/defaults/ini.php` - アプリのiniファイルを正規表現で置換

### 設定ファイル構成

`scripts/defaults/config/`ディレクトリ:
- `general.config.php` - Dock、Finder、キーボード、トラックパッド、カレンダー、Spotlight等
- `apple-apps.config.php` - Terminal、Safari、Xcode
- `non-apple-apps.config.php` - Sequel Pro、iTerm、Evernote、Clipy、BetterSnapTool等

### 設定ファイルの形式

```php
'com.apple.dock' => [
    'autohide' => [
        'read' => 1,           // 期待する現在値
        'write' => '-bool true', // 書き込むdefaultsコマンド引数
        'sudo' => false,       // sudo実行（オプション）
    ],
],
```

- `read`が現在値と一致すればスキップ
- `read`が`null`の場合は削除操作
- PlistBuddyを使う場合はキーに`:`を含める
