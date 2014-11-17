#/bin/sh

# dotfilesのセットアップの直後に実施
# http://ishikawam.github.com/dotfiles/
# 定期的に実行することでインストールツールをログ記録＞yum apt-get homebrew gem npm


# シェルを設定
if [ -f /bin/zsh ]; then
    chsh -s /bin/zsh
elif [ -f /usr/local/bin/zsh ]; then
    chsh -s /usr/local/bin/zsh
else
    echo 'where is zsh?'
fi

# gitのユーザー設定 @todo; これ、将来廃止したい
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
# git commit時の編集エディタをemacsに
git config --global core.editor "/usr/bin/emacs"
# pushするときに現在のブランチのみpush
git config --global push.default tracking
# 日本語ファイル名を表示できるようになる
git config --global core.quotepath false



# スクリプト等インストール yum apt homebrew
# ToDo

if [ -f /usr/libexec/locate.updatedb ]; then
    # エイリアスにしていないのは、sudoで使いたいから
    ln -s /usr/libexec/locate.updatedb ~/this/bin/updatedb
fi


cd
git stash
git pull --rebase
git submodule update --init


# インストールしてあるツールを記録
cd ~/private/
git stash
git checkout master
git pull --rebase

mkdir -p installedtools/`hostname`/`whoami`
if [ -f /usr/bin/apt-get ]; then
	dpkg -l > installedtools/`hostname`/`whoami`/apt
	git add installedtools/`hostname`/`whoami`/apt
fi
if [ -f /usr/bin/yum ]; then
	yum list installed > installedtools/`hostname`/`whoami`/yum
	git add installedtools/`hostname`/`whoami`/yum
fi
if [ -f /usr/local/bin/brew ]; then
	brew ls -la > installedtools/`hostname`/`whoami`/brew
	git add installedtools/`hostname`/`whoami`/brew
fi
if [ -f /usr/bin/gem ]; then
	gem list > installedtools/`hostname`/`whoami`/gem
	git add installedtools/`hostname`/`whoami`/gem
fi
if [ -f ~/.nvm/nvm.sh -o -f /usr/local/bin/npm ]; then
	npm -g ls > installedtools/`hostname`/`whoami`/npm
	git add installedtools/`hostname`/`whoami`/npm
fi

git commit -m "update installedtools/`hostname`/`whoami`"
git push
git stash pop

cd -
git add private
git commit -m "update private"
git push
git stash pop
