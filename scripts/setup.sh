#!/bin/sh

# dotfilesのセットアップの直後に実施
# http://ishikawam.github.com/dotfiles/
# 定期的に実行することでインストールツールをログ記録＞yum apt-get homebrew gem npm
# @todo; 自分じゃなくてcloneしても使えるようにしたい。それだとgit更新系を免除したい。
# @todo; なんどもやらなくていいsetupと、更新とは別にしたい
# @todo; caskはemacs24じゃないと、の判定がいる。


######## setup ##################################################################

# シェルを設定
if [ `uname` = "Darwin" ]; then
    loginshell=`dscl localhost -read Local/Default/Users/$USER UserShell | cut -d' ' -f2 | sed -e 's/^.*\///'`
else
    loginshell=`grep $USER /etc/passwd | cut -d: -f7 | sed -e 's/^.*\///'`
fi
# priority order
if [ ! $loginshell = 'zsh' ]; then
    if [ -f /bin/zsh ]; then
        chsh -s /bin/zsh
    elif [ -f /usr/bin/zsh ]; then
        chsh -s /usr/bin/zsh
    elif [ -f /usr/local/bin/zsh ]; then
        chsh -s /usr/local/bin/zsh
    else
        chsh -s `which zsh`
    fi
fi


# git
# .gitconfigをaddしたのでいらなくなるかも。

# gitのユーザー設定
git config --global user.name "M_Ishikawa"
git config --global user.email "ishikawam@nifty.com"
# gitの設定
git config --global color.ui auto
git config --global alias.co "checkout"
# シンプルなstatus
git config --global alias.st "status -sb"
# pull するときにmergeコミットを作らない
git config --global alias.pr "pull --rebase"
git config --global alias.br "branch"
git config --global alias.fo "fetch origin"
# branchでfoしてroすればmasterにrebaseできる
git config --global alias.ro "rebase origin"
git config --global alias.rc "rebase --continue"
# 単語単位のdiff
git config --global alias.wd "diff --word-diff"
# ブランチ間のdiff
git config --global alias.bd "diff --name-status"
# ログをtreeで表示(簡易tig) via http://webtech-walker.com/archive/2010/03/04034601.html
git config --global alias.lg "log --graph --pretty=oneline --decorate --date=short --abbrev-commit --branches"
# push -f で他人のコミットを改変する可能性がある場合にエラー出してくれる
git config --global alias.pushf "push --force-with-lease"
# git commit時の編集エディタをemacsに
  # localのemacs等あるので、`emacs`指定したい。しかし以前それで問題があった気が。。。
git config --global core.editor "emacs"
# pushするときに現在のブランチのみpush
git config --global push.default upstream
# 日本語ファイル名を表示できるようになる
git config --global core.quotepath false


# スクリプト等インストール yum apt homebrew
# ToDo

# homebrew
if [ `uname` = "Darwin" ]; then
    if [ ! -x "`which brew 2>/dev/null`" ]; then
        # http://brew.sh/index_ja.html
        echo Install Homebrew.
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install tmux gnu-sed mysql tig wget emacs git colordiff global peco imagemagick telnet
    else
        brew update
        brew upgrade
    fi
fi

# mlocate
if [ -f /usr/libexec/locate.updatedb -a ! -f ~/this/bin/updatedb ]; then
    # エイリアスにしていないのは、sudoで使いたいから
    ln -s /usr/libexec/locate.updatedb ~/this/bin/updatedb
fi
# for mac
chmod go+rx Desktop Documents Downloads Movies Music Pictures Dropbox Google\ Drive OneDrive 2>/dev/null

# pyenv
mkdir -p ~/.pyenv/plugins/
if [ -d ~/.pyenv-virtualenv -a ! -d ~/.pyenv/plugins/pyenv-virtualenv ]; then
    ln -s ~/.pyenv-virtualenv ~/.pyenv/plugins/pyenv-virtualenv
fi

# rbenv
mkdir -p ~/.rbenv/plugins/
if [ -d ~/.rbenv-plugins/ruby-build -a ! -d ~/.rbenv/plugins/ruby-build ]; then
    ln -s ~/.rbenv-plugins/ruby-build ~/.rbenv/plugins/ruby-build
fi

# emacs cask
if [ -x "`which cask 2>/dev/null`" ]; then
    # python2.6以上に依存＞cask
    # pyenv install 2.7.9
    echo "cask install."
    cd ~/.emacs.d/ ; cask install ; cd -
fi


######## ssh config ##################################################################

mkdir -p -m 700 ~/.ssh
chmod 600 ~/.ssh/config


######## private ##################################################################

if [ -f ~/private/scripts/setup_private.sh ]; then
    sh ~/private/scripts/setup_private.sh
fi


######## done ##################################################################

echo
echo "please 'source ~/.zshrc'"
echo
