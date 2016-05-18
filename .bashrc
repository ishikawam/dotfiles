## users generic .bashrc file for mac, fedora, Debian, and any linux.
## @author: M.Ishikawa

# 注意：ここでechoしてメッセージを出すとsftpで接続した時にエラーになってしまうので出しちゃだめ


##################################################
# shell variables

# 連続重複した履歴を排除＆空白から始まるコマンドを記録しない
HISTCONTROL=ignoreboth


##################################################
# zsh, bash, commons

source ~/common/.shrc


##################################################
# completions

# git completion
source ~/bin/git-completion.bash


##################################################
# prompt PS1

PS1="[\[\e[36m\]\u\[\e[0m\]@\[\e[32m\]\h \W\[\e[0m\]] \\$ "
