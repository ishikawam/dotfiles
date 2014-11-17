## users generic .bashrc file for mac, fedora, Debian, and any linux.
## @author: M.Ishikawa

# 注意：ここでechoしてメッセージを出すとsftpで接続した時にエラーになってしまうので出しちゃだめ


##################################################
# shell variables

# 連続重複した履歴を排除＆空白から始まるコマンドを記録しない
HISTCONTROL=ignoreboth


##################################################
# path

# Android SDK
PATH=$PATH:/Applications/android-sdk-mac_x86/platform-tools
PATH=$PATH:~/android-sdks/platform-tools

PATH=$PATH:/Applications/android-sdk-mac_x86/tools
PATH=$PATH:~/android-sdks/tools

# 個人bin
PATH=~/bin:$PATH
# this 個別設定
PATH=~/this/bin:$PATH
# 非公開の
PATH=~/private/bin:$PATH

# sbin
PATH=$PATH:/sbin:/usr/sbin

# homebrewを優先。gitとか
PATH=/usr/local/bin:$PATH

# Terminalの色数
TERM=xterm-256color

# Mac標準のBSD版sedはイケてないのでgnu版に替える
if [ -d /usr/local/opt/gnu-sed/ ]; then
    PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
fi

# dockerの設定
DOCKER_HOST=tcp://localhost:4243

# go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin


##################################################
# aliases

# Macと場合分け。lsが異なるので。
case "$OSTYPE" in
    darwin*)
        alias ls="LSCOLORS=gxfxxxxxcxxxxxxxxxxxxx ls -G"
        alias ll='ls -lahF'
        ;;
    linux*)
        alias ls="ls --color=auto"
        alias ll='ls -lahF --color=auto'
        ;;
    freebsd*)
        alias ls="LSCOLORS=gxfxxxxxcxxxxxxxxxxxxx ls -G"
        alias ll='ls -lahF'
esac

alias rm='rm -i'
alias cp='cp -iv'
alias mv='mv -iv'
alias ggrep="grep --exclude-dir='htdocs*' --exclude-dir='log' --exclude='*.json' --exclude-dir='node_modules'"
alias grep="grep --color --binary-files=without-match --exclude-dir='.svn' --exclude-dir='.git' --exclude='*.png' --exclude='*.jpg' --exclude='*.gif' --exclude='*.ico' --exclude-dir='tmp' "

alias findname='find . -name $*'
function findgrep() { find . -type f -name "$1" -exec grep -lHn "$2" {} \;; }
function findrm() { find . -type f -name "$1" -exec rm -f "$2" {} \;; }
function findsed() { find . -type f -name "$1" -exec sed -e "$2" {} \;; }
function findsedexec() { find . -type f -name "$1" -exec sed -i -e "$2" {} \;; }

alias -- .='pwd -P'
alias -- ..='cd ..'
../() { cd ../; }
alias -- ...='cd ../..'
.../() { cd ../..; }
alias -- -='cd -'

alias scl='screen -ls'
alias scr='screen -xR'

alias e='emacs'
alias em='emacs -q -l ~/.emacs_min'

alias mysql_delete_danger_history='sed -i -e "/\(drop\|DROP\) /D" ~/.mysql_history'


##################################################
# node

# nodeのバージョン決定
if [ -f ~/.nvm/nvm.sh ]; then
    source ~/.nvm/nvm.sh

    if [ $(hostname) = "test-air2.local" ]; then
        nvm use v0.10.22 > /dev/null
    elif [ $(hostname) = "ishikawa-air2.local" ]; then
        nvm use v0.10.15 > /dev/null
    elif [[ $(hostname) =~ "^g-pc-4529" ]]; then
        nvm use v0.10.22 > /dev/null
    elif [ $(hostname) = "wind.windserver.jp" ]; then
        nvm use v0.6.13 > /dev/null
    elif [ $(hostname) = "fire" ]; then
        # fireでnodeのサービス動いているので合わせる。サービスは /etc/rc.d/rc.local
        nvm use v0.10.31 > /dev/null
    fi

    npm_dir=${NVM_PATH}_modules
    NODE_PATH=$npm_dir
fi

# npmgls, npmgls
alias npmls='npm ls | grep -v "^ \|│" | sed -e "s/^.* //g"'
alias npmgls='npm ls -g | grep -v "^ \|│" | sed -e "s/^.* //g"'


##################################################
# lang

# 言語、デフォルトはUTF-8
LANG=ja_JP.UTF-8
alias chlang-utf8='LANG=ja_JP.UTF-8'
alias chlang-eucjp='LANG=ja_JP.EUC-JP'

# euc判定
if [ -f ~/this/.eucjp ]; then
    LANG=ja_JP.EUC-JP
fi


##################################################
# completions

# git completion
source ~/bin/git-completion.bash


##################################################

# crontab editor is emacs
export EDITOR=/usr/bin/emacs

# for mosh, tmux
if [ `uname` = "Darwin" ]; then
    # Mountain Lionの "dyld: DYLD_ environment variables being ignored because main executable (/usr/bin/sudo) is setuid or setgid" 問題対応
    unset LD_LIBRARY_PATH
    unset DYLD_LIBRARY_PATH
else
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
fi

# tmux show git branch 効いてない
PS1="$PS1"$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")

# ignore ssl certificate when using git
export GIT_SSL_NO_VERIFY=true


##################################################
# login check
watch=(notme)
LOGCHECK=10
WATCHFMT="%(a:${fg[blue]}Hello %n [%m] [%t]:${fg[red]}Bye %n [%m] [%t])"


##################################################
# private shell

if [ -f ~/private/.shrc ]; then
    source ~/private/.shrc
fi
