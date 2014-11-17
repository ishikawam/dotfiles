## users generic .zshrc file for mac, fedora, Debian, and any linux.
## @author: M.Ishikawa

# 注意：ここでechoしてメッセージを出すとsftpで接続した時にエラーになってしまうので出しちゃだめ


##################################################
# shell variables

# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups
# スペースで始まるコマンドラインはヒストリリストから削除
setopt hist_ignore_space

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# historyに時刻を残す
setopt extended_history
# 途中まで打ってから上下で関連履歴に
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# 3秒以上かかった処理は詳細表示
REPORTTIME=3

# prompt
PROMPT=$'%{\e[1;30m%}[%{\e[m%}%{\e[0;36m%}%n%{\e[m%}%{\e[0;37m%}@%{\e[m%}%{\e[0;32m%}%U%M%u %.%{\e[m%}%{\e[1;30m%}]%{\e[m%} %# '

# pre cmd
function precmd_vcs() {
    if [[ $ZSH_VERSION == (<5->|4.<4->|4.3.<10->)* ]]; then
        vcs_info
    fi
    RPROMPT=$'%{\e[32m%}%~'${vcs_info_msg_0_}$'%{\e[m%}'
}
precmd_functions+=(precmd_vcs)


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

# 最後に重複PATHを掃除
typeset -U path PATH
# 存在しないPATHを排除
path=(${^path}(N-/))


##################################################
# zsh-syntax-highlighting
source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


##################################################
# aliases

# Macと場合分け。lsが異なるので。
case "$OSTYPE" in
    darwin*)
        alias ls="LSCOLORS=gxfxxxxxcxxxxxxxxxxxxx ls -G"
        alias -s html='open -a Google\ Chrome'
        alias -s {png,jpg,bmp,PNG,JPG,pdf}='open -a Preview'
        alias ll='ls -lahF'
        ;;
    linux*)
        alias ls="ls --color=auto"
        alias ll='ls -lahF --color=auto'
        ;;
    freebsd*)
        alias ls="LSCOLORS=gxfxxxxxcxxxxxxxxxxxxx ls -G"
        alias ll='ls -lahF'
        # zshにメールチェックをさせない
        export MAILCHECK=0
;;
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

# zshのエラー回避
setopt nonomatch

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
# zsh bindkey

# emacs
bindkey -e

bindkey '^U' backward-kill-line

if [[ $ZSH_VERSION == (<5->|4.<4->|4.3.<10->)* ]]; then
    # zsh のバージョンが4.3.10以上ならワイルドカードが使える
    bindkey '^R' history-incremental-pattern-search-backward
    bindkey '^S' history-incremental-pattern-search-forward
    bindkey '^[r' history-incremental-pattern-search-forward
    # ↑書いているけどC-sが効かないのでM-rにもバインド。
else
    bindkey '^R' history-incremental-search-backward
    bindkey '^S' history-incremental-search-forward
fi

# M-f/M-bの挙動をEmacsのそれに合わせる（実はM-bは元々同じだけど一応）
bindkey "^[f" emacs-forward-word
bindkey "^[b" emacs-backward-word
# M-f/M-b/M-dなどでの単語境界の基準をemacsライクに
export WORDCHARS=""

# 途中まで打ってから上下で関連履歴に
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


##################################################
# others

# cd補完
setopt autopushd
# 同じディレクトリは追加しない
setopt pushdignoredups
# 右に出るプロンプトを非表示
setopt transient_rprompt


##################################################
# completions

# zsh-completions
fpath=(~/.zsh-completions/src $fpath)

autoload -Uz compinit
compinit

autoload colors
colors

# git completion
autoload -U bashcompinit
bashcompinit
source ~/bin/git-completion.bash


zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B--- %d ---%b'

zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ln=35 di=36

zstyle ':completion:*:kill:*:processes' command 'ps x'
zstyle ':completion:*:-command-:*' fake-parameters PERL5LIB # for perl

# 補完の時に大文字小文字を区別しない
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# sudo でも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# ../とした時に今いるディレクトリを補完候補から外す
zstyle ':completion:*' ignore-parents parent pwd ..

# vcs
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' formats $'%{\e[35m%} [%s %r %b]%{\e[m%}'

# word-style
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;:@"
zstyle ':zle:*' word-style unspecified

#Default
#
#zstyle ':completion:*' auto-description 'specify: %d'
#zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
#
#zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true
#
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


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
