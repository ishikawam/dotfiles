setup:
	sh ~/scripts/setup.sh
	php ~/scripts/defaults.php
	if [ -f ~/private/scripts/setup_private.sh ]; then sh ~/private/scripts/setup_private.sh ; fi

install:
	make setup

chrome:
	cd ~/Library/Application\ Support/Google/Chrome/Default/ ; ln -sf ~/common/Chrome/Default/.gitignore ./ ; git init

gitignore_checker:
	ln -sf ~/.gitignore_checker ~/.gitignore

mas-list:
	cat ~/private/installedtools/*/*/mas | sort -n | uniq

agree-apps:
	yes | sh ~/scripts/agreeApps.sh
