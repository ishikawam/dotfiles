setup:
	sh scripts/setup.sh

install:
	make setup

chrome:
	cd ~/Library/Application\ Support/Google/Chrome/Default/ ; ln -sf ~/common/Chrome/Default/.gitignore ./ ; git init
