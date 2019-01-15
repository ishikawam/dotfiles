# shellじゃないのでifをやめないと。

setup:
	sh ~/scripts/setup.sh
	sh ~/scripts/setup_mac.sh
	make defaults
#	make agree-apps
	if [ -f ~/private/scripts/setup_private.sh ]; then sh ~/private/scripts/setup_private.sh ; fi

setup-private:
# installedを保存するくらい
	sh ~/private/scripts/setup_private.sh

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
	if [ "`which defaults 2>/dev/null`" ]; then php ~/scripts/defaults.php ; killall Finder ; killall Dock ; fi

defaults-dryrun:
	if [ "`which defaults 2>/dev/null`" ]; then php ~/scripts/defaults.php --dry-run ; fi

updates:
	sh bin/updates
