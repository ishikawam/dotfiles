# dotfiles

M_Ishikawa

macでもFedoraでもCentOSでもDebianでもUbuntuでも。
事前にzshは必須。


* メモ：
  * tmux-powerline はsubmodule化したかったけどmytheme.shを変えないといけないので取り込んだ


### bin/

共通のコマンド

### private/bin/

共通の秘密コマンド

### this/bin/

リポジトリ管理しない個別のコマンド置き場


http://ishikawam.github.com/dotfiles/


```
$ cd
$ git clone -n git@github.com:ishikawam/dotfiles.git
$ mv dotfiles/.git ../
$ git reset
$ git checkout .
$ rm -rf dotfiles
$ sh ~/bin/setup.sh
```
