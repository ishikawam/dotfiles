# dotfiles

M_Ishikawa

macでもFedoraでもCentOSでもDebianでもUbuntuでも。
事前にzshは必須。
ツールはphp, php-mbstring, が必要なものも。

```
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


http://ishikawam.github.com/dotfiles/


## setup

```
curl -fsSL https://raw.githubusercontent.com/ishikawam/dotfiles/master/scripts/install.sh | sh
```

see https://raw.githubusercontent.com/ishikawam/dotfiles/master/scripts/install.sh
