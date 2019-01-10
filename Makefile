setup:
	sh ~/scripts/setup.sh
	php ~/scripts/defaults.php
	if [ -f ~/private/scripts/setup_private.sh ]; then sh ~/private/scripts/setup_private.sh ; fi

install:
	make setup

gitignore_checker:
	ln -sf ~/.gitignore_checker ~/.gitignore

mas-list:
	cat ~/private/installedtools/*/*/mas | sort -n | uniq

agree-apps:
	yes | sh ~/scripts/agreeApps.sh

record-installed-tools:
	sh ~/private/scripts/recordInstalledTools.sh

defaults:
	php ~/scripts/defaults.php
