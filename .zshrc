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

# zshのエラー回避
setopt nonomatch


##################################################
# zsh-syntax-highlighting
source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


##################################################
# zsh, bash, commons

source ~/common/.shrc


##################################################
# path

# 最後に重複PATHを掃除
typeset -U path PATH
# 存在しないPATHを排除
#path=(${^path}(N-/))
# やらない。 PATH=$PATH:./node_modules/.bin とか、カレントディレクトリから参照させたいやつはホームディレクトリにあると限らないから。



##################################################
# aliases

case "$OSTYPE" in
    darwin*)
        alias -s html='open -a Google\ Chrome'
        alias -s {png,jpg,bmp,PNG,JPG,pdf}='open -a Preview'
        ;;
    freebsd*)
        # zshにメールチェックをさせない
        export MAILCHECK=0
        ;;
esac


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
compinit -u

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

