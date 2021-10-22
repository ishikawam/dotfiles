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


##################################################
# direnv

if type 'direnv' > /dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi


##################################################
# gcloud

if [ -e /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk ]; then
    source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
    source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
fi
