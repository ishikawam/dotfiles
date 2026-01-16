# dotfiles

M_Ishikawa

macでもFedoraでもCentOSでもDebianでもUbuntuでも。
事前にzshは必須。
ツールはphp, php-mbstring, が必要なものも。

```shell
sudo localedef -f UTF-8 -i ja_JP ja_JP
```

も。

* メモ：
  * tmux-powerline はsubmodule化したかったけどmytheme.shを変えないといけないので取り込んだ


### bin/

共通のコマンド

### private/bin/

共通の秘密コマンド

### this/bin/

リポジトリ管理しない個別のコマンド置き場


## setup

```shell
curl -fsSL https://raw.githubusercontent.com/ishikawam/dotfiles/master/scripts/install.sh | sh
```

see https://raw.githubusercontent.com/ishikawam/dotfiles/master/scripts/install.sh

## sudoのない共用サーバへの設置

```shell
mkdir -p ~/home
cd ~/home
# 名前は適当に変更して
git clone git@github.com:ishikawam/dotfiles.git masayuki-ishikawa
cd masayuki-ishikawa
git submodule update
git submodule deinit private
```

これで環境変数 `HOME` を変えてshellを起動すればdotfiles環境に入れます。

```shell
# 例) cshからzsh (ex. さくらのレンタルサーバ)
env HOME=$HOME/home/masayuki-ishikawa zsh
# bashからbash (ex. XSERVER)
HOME=$HOME/home/masayuki-ishikawa bash
```

起動を楽にするには

```shell
echo "$PATH" | tr ':' '\n'
```

で権限のあるところにコマンド作るとか.rcにalias書くとかで。

```shell
#!/bin/csh

env HOME=$HOME/home/masayuki-ishikawa zsh
```

```shell
#!/bin/bash

HOME=$HOME/home/masayuki-ishikawa bash
```

`chmod 755` 忘れずに。

## make defaults

macOSのシステム設定やアプリ設定を`defaults`コマンドと`PlistBuddy`で自動適用する。

### 使い方

```shell
# 有効化
make set-force-defaults

# 実行
make defaults

# ドライラン
make defaults-dryrun
```

### 設定ファイル

`scripts/defaults/config/`に設定ファイルがある。

| ファイル | 内容 |
|---------|------|
| `general.config.php` | Dock、Finder、キーボード、トラックパッド、カレンダー、Spotlight等 |
| `apple-apps.config.php` | Terminal、Safari、Xcode |
| `non-apple-apps.config.php` | Sequel Pro、iTerm、Evernote、Clipy、BetterSnapTool等 |

`scripts/defaults/ini.php`はLINE、Slackの設定ファイルを管理する。

### 主な設定内容

- Dock: 自動で隠す、左側配置、拡大機能、ホットコーナー
- Finder: 隠しファイル表示、ステータスバー・パスバー表示、リストビュー
- キーボード: キーリピート速度、自動修正無効化、ショートカットキー
- トラックパッド: タップでクリック、3本指ドラッグ、Force Click無効化
- アプリ設定: 自動更新、スペルチェック無効化、ショートカットキー

### 注意

- `~/this/.force-defaults`フラグがないと実行されない
- 実行後はmacの再起動が必要な場合がある
- 一部の設定はmacOSのバージョンによって動作しない場合がある

### emacs

straight.elを取得できない場合は手動で取得

```shell
mkdir -p ~/.emacs.d/straight/repos
cd ~/.emacs.d/straight/repos

git clone https://github.com/radian-software/straight.el.git
```
