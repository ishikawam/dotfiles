
setup:
	sh ~/scripts/setup.sh
	sh ~/scripts/setup_mac.sh
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
	yes | sh ~/scripts/agreeApps.sh

record-installed-tools:
	bash ~/private/scripts/recordInstalledTools.sh

defaults:
	php ~/scripts/defaults.php

defaults-dryrun:
	php ~/scripts/defaults.php --dry-run

updates:
	sh bin/updates

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
