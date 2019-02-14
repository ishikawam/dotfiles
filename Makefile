
setup:
	bash ~/scripts/setup.sh
	bash ~/scripts/setup_mac.sh
	make defaults
#	make agree-apps
	if [ -f ~/private/scripts/setup_private.sh ]; then bash ~/private/scripts/setup_private.sh ; fi

setup-private:
# installedを保存するくらい
	bash ~/private/scripts/setup_private.sh

install:
	make setup

gitignore_checker:
	ln -sf ~/.gitignore_checker ~/.gitignore

mas-list:
	cat ~/private/installedtools/*/*/mas | sort -n | uniq

agree-apps:
	yes | bash ~/scripts/agreeApps.sh

record-installed-tools:
	bash ~/private/scripts/recordInstalledTools.sh

defaults:
	php ~/scripts/defaults/defaults.php
	php ~/scripts/defaults/ini.php

defaults-dryrun:
	php ~/scripts/defaults/defaults.php --dry-run

updates:
	sh bin/updates
	git submodule foreach git pull origin master

chrome-reset:
	-killall Google\ Chrome ; sleep 10
	cd ~/Library/Application\ Support/Google/Chrome/Default/ ; git checkout . ; git status -sb ; git log | head -12
	sleep 1
	open /Applications/Google\ Chrome.app

chrome-rollback:
	-killall Google\ Chrome ; sleep 10
	cd ~/Library/Application\ Support/Google/Chrome/Default/ ; git checkout . ; git reset HEAD^ ; git checkout . ; git status -sb ; git log | head -12
	sleep 1
	open /Applications/Google\ Chrome.app

ruby-install-latest:
	rbenv install -s `rbenv install --list | grep "^ *[0-9.]*$$" | tail -1`
	rbenv global `rbenv install --list | grep "^ *[0-9.]*$$" | tail -1`
	sudo gem update --system
	sudo gem update

# private/installedtoolsに全部置く場合
set-ignore-sparse:
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."
	touch ~/this/.ignore-sparse
	@test -f ~/this/.ignore-sparse && echo "to exits." || echo "to not exists."

# private/installedtoolsに自分のしか置かない場合 (デフォルト)
remove-ignore-sparse:
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."
	rm -f ~/this/.ignore-sparse
	@test -f ~/this/.ignore-sparse && echo "to exits." || echo "to not exists."

# defaultsを実行 & アップデート する場合
set-force-defaults:
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."
	touch ~/this/.force-defaults
	@test -f ~/this/.force-defaults && echo "to exits." || echo "to not exists."

# defaultsを実行 & アップデート しない場合 (デフォルト)
remove-force-defaults:
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."
	rm -f ~/this/.force-defaults
	@test -f ~/this/.force-defaults && echo "to exits." || echo "to not exists."
