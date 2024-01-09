
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
	-php ~/scripts/defaults/ini.php

defaults-dryrun:
	php ~/scripts/defaults/defaults.php --dry-run

# privatee ,Libraryが直書きなの @todo;
fetch:
	git -C ~/ fetch ; git -C ~/ st
	git -C ~/private fetch ; git -C ~/private st
	if [ -d ~/Library ]; then git -C ~/Library fetch ; git -C ~/Library st ; fi

replace:
	@if [ ! -e /Users/m_ishikawa ]; then sudo mkdir -m 777 /Users/m_ishikawa ; ln -s /Users/masayuki.ishikawa/Dropbox /Users/m_ishikawa/ ; fi
	@gsed -i -e "s/\/Users\/masayuki\.ishikawa\//\/Users\/m_ishikawa\//g" \
		~/Library/Containers/com.sequel-ace.sequel-ace/Data/Library/Application\ Support/Sequel\ Ace/Data/Favorites.plist
	git -C ~/Library diff

pr:
	git -C ~/ pr ; git -C ~/ st
	git -C ~/private pr ; git -C ~/private st
	if [ -d ~/Library ]; then git -C ~/Library pr ; git -C ~/Library st ; fi

updates:
	sh ~/bin/updates
# pull main or master
	git submodule foreach 'case $name in scripts/create_docker_laravel_project) git pull origin main ;; *) git pull origin master ;; esac'

ruby-install-latest:
	rbenv install -s `rbenv install --list | grep "^ *[0-9.]*$$" | tail -1`
	rbenv global `rbenv install --list | grep "^ *[0-9.]*$$" | tail -1`
	sudo gem update --system
	sudo gem update

# private/installedtoolsに全部置く場合
set-ignore-sparse:
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."
	touch ~/this/.ignore-sparse
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."

# private/installedtoolsに自分のしか置かない場合 (デフォルト)
remove-ignore-sparse:
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."
	rm -f ~/this/.ignore-sparse
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."

# defaultsを実行 & アップデート する場合
set-force-defaults:
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."
	touch ~/this/.force-defaults
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."

# defaultsを実行 & アップデート しない場合 (デフォルト)
remove-force-defaults:
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."
	rm -f ~/this/.force-defaults
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."
