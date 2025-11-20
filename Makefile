.DEFAULT_GOAL := help

.PHONY: help
help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## 初回セットアップ（Mac環境）
	bash ~/scripts/setup.sh
	bash ~/scripts/setup_mac.sh
#	make defaults  # 長らくメンテされていない
#	make agree-apps
	make setup-gh-hosts
	if [ -f ~/private/scripts/setup_private.sh ]; then bash ~/private/scripts/setup_private.sh ; fi

setup-private: ## プライベート設定のセットアップ
	bash ~/private/scripts/setup_private.sh

install: ## setupのエイリアス
	make setup

gitignore_checker: ## gitignoreをチェッカーモードに切り替え
	ln -sf ~/.gitignore_checker ~/.gitignore

setup-gh-hosts: ## GitHub CLI hosts.ymlをホスト名に応じて切り替え
	@echo "Setting up GitHub CLI hosts.yml based on hostname..."
	@hostname=$$(hostname); \
	if [[ $$hostname =~ ^ishikawa- ]]; then \
		echo "Hostname starts with 'ishikawa-': Using hosts.yml.ishikawam"; \
		cd ~/.config/gh && \
		rm -f hosts.yml && \
		ln -s hosts.yml.ishikawam hosts.yml; \
	else \
		echo "Hostname does not start with 'ishikawa-': Using hosts.yml.masayuk-ishikaw"; \
		cd ~/.config/gh && \
		rm -f hosts.yml && \
		ln -s hosts.yml.masayuk-ishikaw hosts.yml; \
	fi
	@echo "Current hosts.yml symlink:"
	@ls -l ~/.config/gh/hosts.yml

mas-list: ## Mac App Storeインストール済みアプリ一覧
	cat ~/private/installedtools/*/*/mas | sort -n | uniq

agree-apps: ## アプリの利用規約に同意
	yes | bash ~/scripts/agreeApps.sh

record-installed-tools: ## インストール済みツールを記録
	bash ~/private/scripts/recordInstalledTools.sh

defaults: ## macOSのデフォルト設定を適用
	php ~/scripts/defaults/defaults.php
	-php ~/scripts/defaults/ini.php

defaults-dryrun: ## デフォルト設定をドライラン
	php ~/scripts/defaults/defaults.php --dry-run

fetch: ## 全リポジトリ（~/、~/private、~/Library）をフェッチ
	git -C ~/ fetch ; git -C ~/ st
	git -C ~/private fetch ; git -C ~/private st
	if [ -d ~/Library ]; then git -C ~/Library fetch ; git -C ~/Library st ; fi

replace: ## Sequel Ace設定のパスを短縮形に置換
	@if [ ! -e /Users/m_ishikawa ]; then sudo mkdir -m 777 /Users/m_ishikawa ; ln -s /Users/masayuki.ishikawa/Dropbox /Users/m_ishikawa/ ; fi
	@gsed -i -e "s/\/Users\/masayuki\.ishikawa\//\/Users\/m_ishikawa\//g" \
		~/Library/Containers/com.sequel-ace.sequel-ace/Data/Library/Application\ Support/Sequel\ Ace/Data/Favorites.plist
	git -C ~/Library diff

pr: ## 全リポジトリをpull rebase
	git -C ~/ pr ; git -C ~/ st
	git -C ~/private pr ; git -C ~/private st
	if [ -d ~/Library ]; then git -C ~/Library pr ; git -C ~/Library st ; fi

updates: ## 全リポジトリを更新＆サブモジュール更新
	sh ~/bin/updates
	git submodule foreach 'case $$name in scripts/create_docker_laravel_project) git pull origin main ;; *) git pull origin master ;; esac'

ruby-install-latest: ## 最新のRubyをインストール
	rbenv install -s `rbenv install --list | grep "^ *[0-9.]*$$" | tail -1`
	rbenv global `rbenv install --list | grep "^ *[0-9.]*$$" | tail -1`
	sudo gem update --system
	sudo gem update

set-ignore-sparse: ## private/installedtoolsを全て含めるモードに設定
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."
	touch ~/this/.ignore-sparse
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."

remove-ignore-sparse: ## private/installedtoolsを自分のみ含めるモードに設定（デフォルト）
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."
	rm -f ~/this/.ignore-sparse
	@test -f ~/this/.ignore-sparse && echo "exits." || echo "not exists."

set-force-defaults: ## defaultsを実行＆アップデートするモードに設定
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."
	touch ~/this/.force-defaults
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."

remove-force-defaults: ## defaultsを実行＆アップデートしないモードに設定（デフォルト）
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."
	rm -f ~/this/.force-defaults
	@test -f ~/this/.force-defaults && echo "exits." || echo "not exists."

claude-improve-settings: ## 全プロジェクトからClaude Code権限を収集し~/.claude/settings.jsonを更新
	@echo "Claude Codeプロジェクトを検索中..."
	@projects=$$(find ~/git -name .claude 2>/dev/null); \
	if [ -z "$$projects" ]; then \
		echo "Claude Codeプロジェクトが見つかりませんでした"; \
		exit 1; \
	fi; \
	echo "発見されたプロジェクト数: $$(echo "$$projects" | wc -l)"; \
	echo ""; \
	echo "=== ~/.claude/settings.json を更新 ==="; \
	mkdir -p ~/.claude; \
	echo "$$projects" | while read project; do \
		if [ -n "$$project" ] && [ -f "$$project/settings.local.json" ]; then \
			if command -v jq >/dev/null 2>&1; then \
				cat "$$project/settings.local.json" | jq -r '.permissions.allow[]? // empty' 2>/dev/null; \
			else \
				grep '"' "$$project/settings.local.json" | grep -E '(Bash|WebFetch|Task)' | sed 's/.*"//;s/".*//' | grep -v '^$$'; \
			fi; \
		fi; \
	done | sort -u | grep -v '^$$' > /tmp/claude_permissions; \
	if [ -f ~/.claude/settings.json ]; then \
		if command -v jq >/dev/null 2>&1; then \
			cat ~/.claude/settings.json | jq -r '.permissions.allow[]? // empty' 2>/dev/null | sort -u > /tmp/claude_existing; \
		else \
			grep '"' ~/.claude/settings.json | grep -E '(Bash|WebFetch|Task)' | sed 's/.*"//;s/".*//' | grep -v '^$$' | sort -u > /tmp/claude_existing; \
		fi; \
		cat /tmp/claude_existing /tmp/claude_permissions 2>/dev/null | sort -u | grep -v '^$$' > /tmp/claude_all_permissions; \
	else \
		cp /tmp/claude_permissions /tmp/claude_all_permissions; \
	fi; \
	echo '{' > ~/.claude/settings.json; \
	echo '  "permissions": {' >> ~/.claude/settings.json; \
	echo '    "allow": [' >> ~/.claude/settings.json; \
	if [ -s /tmp/claude_all_permissions ]; then \
		cat /tmp/claude_all_permissions | sed 's/^/      "/;s/$$/",/' | sed '$$s/,$$//' >> ~/.claude/settings.json; \
	fi; \
	echo '    ],' >> ~/.claude/settings.json; \
	echo '    "deny": []' >> ~/.claude/settings.json; \
	echo '  }' >> ~/.claude/settings.json; \
	echo '}' >> ~/.claude/settings.json; \
	if [ -s /tmp/claude_all_permissions ]; then \
		echo "権限数: $$(cat /tmp/claude_all_permissions | wc -l)"; \
	else \
		echo "権限数: 0"; \
	fi; \
	echo ""; \
	echo "settings.json の更新完了！"

claude-improve-doc: ## 全プロジェクトのCLAUDE.mdからグローバル設定候補を抽出
	@echo "Claude Codeプロジェクトを検索中..."
	@projects=$$(find ~/git -name .claude 2>/dev/null); \
	if [ -z "$$projects" ]; then \
		echo "Claude Codeプロジェクトが見つかりませんでした"; \
		exit 1; \
	fi; \
	echo "発見されたプロジェクト数: $$(echo "$$projects" | wc -l)"; \
	echo ""; \
	echo "=== 各プロジェクトでClaude Codeを実行 ==="; \
	for project in $$projects; do \
		if [ -n "$$project" ]; then \
			project_dir="$$(dirname "$$project")"; \
			claude_md="$$project_dir/CLAUDE.md"; \
			if [ -f "$$claude_md" ]; then \
				echo ""; \
				echo "--- $$project_dir ---"; \
				echo "CLAUDE.mdが存在します"; \
				echo "このディレクトリでClaude Codeを実行します..."; \
				(cd "$$project_dir" && claude -p "このプロジェクトのCLAUDE.mdから、グローバルの設定としても良さそうなものをピックアップしてください。それを ~/.claude/CLAUDE.md に追記反映させてください。") || echo "Claude実行中にエラーが発生しました"; \
			else \
				echo ""; \
				echo "--- $$project_dir ---"; \
				echo "CLAUDE.mdが存在しません（スキップ）"; \
			fi; \
		fi; \
	done; \
	echo ""; \
	echo "全プロジェクトでの実行完了！"

migrate-data: ## 対話式データ移行ツール（旧Mac→新Mac）
	bash ~/scripts/migrate_data.sh

alfred-import-custom-search: ## Alfredにカスタムサーチをインポート
	@echo "Alfredにカスタムサーチをインポート中..."
	open "alfred://customsearch/alc/alc/ascii/nospace/http%3A%2F%2Feow.alc.co.jp%2Fsearch%3Fq%3D%7Bquery%7D"
	open "alfred://customsearch/Confluence%20Search/confl/ascii/nospace/https%3A%2F%2Fconfluence.gree-office.net%2Fdosearchsite.action%3FqueryString%3D%7Bquery%7D"
	open "alfred://customsearch/Google%20Drive%20Search/dri/ascii/nospace/https%3A%2F%2Fdrive.google.com%2Fa%2Fgree.co.jp%2F%23search%2F%7Bquery%7D"
	open "alfred://customsearch/Evernote%20Search/ever/ascii/nospace/evernote%3A%2F%2Fsearch%2F%7Bquery%7D"
	open "alfred://customsearch/emp/emp/utf8/nospace/https%3A%2F%2Femp-gree-office.appspot.com%2Femp"
	open "alfred://customsearch/mis/mis/utf8/nospace/https%3A%2F%2Frefactoring.gree-dev.net%2Femployee%2Fsearch%3Fq%3D%7Bquery%7D"
	open "alfred://customsearch/mis_old/mis_old/ascii/nospace/https%3A%2F%2Fworkflow.gree-office.net%2Fimart%2Fgree%2Femployee%2FemployeeSearch%2F%3FemployeeId%3D%26mailAddress%3D%26faceImage%3Dyes%26name%3D%7Bquery%7D%26search%3DSearch"
	open "alfred://customsearch/Portal%20Search/po/utf8/nospace/https%3A%2F%2Fgreeoffice.sharepoint.com%2F_layouts%2F15%2Fsearch.aspx%2Fsiteall%3Fq%3D%7Bquery%7D"
	open "alfred://customsearch/Portal/por/utf8/nospace/https%3A%2F%2Fgreeoffice.sharepoint.com%2F"
	open "alfred://customsearch/%E7%BF%BB%E8%A8%B3/trans/utf8/nospace/http%3A%2F%2Ftranslate.google.co.jp%2F%23en%2Fja%2F%7Bquery%7D"
	@echo "完了しました"

chrome-install-extensions: ## Chrome拡張機能のインストール
	@echo "Chrome拡張機能のセットアップを行います"
	@echo ""
	@echo "以下の順で進行します："
	@echo "  1. Chrome拡張機能をインストール"
	@echo "  2. 各拡張機能の基本設定"
	@echo "  3. 拡張機能の詳細設定"
	@echo ""
	@read -p "拡張機能のインストールページをブラウザで開きますか？ (y/N): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo ""; \
		echo "1/8: Session Buddy"; \
		open "https://chrome.google.com/webstore/detail/session-buddy/edacconmaakjimmfgnblocblbcdcpbko?hl=ja"; \
		echo "2/8: Google Translate"; \
		open "https://chrome.google.com/webstore/detail/google-translate/aapbdbdomjkkjkaonfhkkikfgjllcleb"; \
		echo "3/8: GoFullPage"; \
		open "https://chrome.google.com/webstore/detail/gofullpage-full-page-scre/fdpohaocaechififmbbbbbknoalclacl"; \
		echo "4/8: JSONView"; \
		open "https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc"; \
		echo "5/8: Quick Tabs"; \
		open "https://chrome.google.com/webstore/detail/quick-tabs/jnjfeinjfmenlddahdjdmgpbokiacbbb"; \
		echo "6/8: One Tab"; \
		open "https://chrome.google.com/webstore/detail/onetab/chphlpgkkbolifaimnlloiipkdnihall"; \
		echo "7/8: The Marvellous Suspender"; \
		open "https://chrome.google.com/webstore/detail/the-marvellous-suspender/noogafoofpebimajpfpamcfhoaifemoa"; \
		echo "8/8: Tampermonkey"; \
		open "https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo"; \
		echo ""; \
		echo "全ての拡張機能のインストールページを開きました"; \
		echo ""; \
		echo "========================================="; \
		read -p "ブラウザで全ての拡張機能のインストールが完了したらEnterキーを押してください..." dummy2; \
	else \
		echo "インストールをスキップしました"; \
	fi
	@echo ""
	@read -p "次に各拡張機能の基本設定ページを開きますか？ (y/N): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo ""; \
		echo "========================================"; \
		echo "【各拡張機能の基本設定】chrome://extensions での設定"; \
		echo "========================================"; \
		echo ""; \
		echo "以下の設定を行ってください："; \
		echo ""; \
		echo "■ Session Buddy"; \
		echo "  - Allow in Incognito"; \
		echo "  - Allow access to file URLs"; \
		echo ""; \
		echo "■ Google Translate"; \
		echo "  - Allow in Incognito"; \
		echo ""; \
		echo "■ GoFullPage"; \
		echo "  - Allow in Incognito"; \
		echo ""; \
		echo "■ JSONView"; \
		echo "  - Allow in Incognito"; \
		echo ""; \
		echo "■ Quick Tabs"; \
		echo "  - Allow in Incognito"; \
		echo ""; \
		echo "設定ページを開きます..."; \
		echo ""; \
		open -a "Google Chrome" "chrome://extensions/?id=edacconmaakjimmfgnblocblbcdcpbko"; \
		open -a "Google Chrome" "chrome://extensions/?id=aapbdbdomjkkjkaonfhkkikfgjllcleb"; \
		open -a "Google Chrome" "chrome://extensions/?id=fdpohaocaechififmbbbbbknoalclacl"; \
		open -a "Google Chrome" "chrome://extensions/?id=chklaanhfefbnpoihckbnefhakgolnmc"; \
		open -a "Google Chrome" "chrome://extensions/?id=jnjfeinjfmenlddahdjdmgpbokiacbbb"; \
		echo ""; \
		read -p "基本設定が完了したらEnterキーを押してください..." dummy3; \
	else \
		echo "基本設定をスキップしました"; \
	fi
	@echo ""
	@read -p "次に拡張機能の詳細設定ページを開きますか？ (y/N): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo ""; \
		echo "========================================"; \
		echo "【拡張機能の詳細設定】"; \
		echo "========================================"; \
		echo ""; \
		echo "以下の設定を行ってください："; \
		echo ""; \
		echo "■ Google Translate"; \
		echo "  - 日本語に設定"; \
		echo ""; \
		echo "■ GoFullPage"; \
		echo "  - Directory: ~/Downloads/GoFullPage/"; \
		echo "  - Auto-download files をチェック (で、タブを移動させない"; \
		echo ""; \
		echo "■ Quick Tabs"; \
		echo "  - Perform RegEx Search"; \
		echo "  - Always search URLs をオン"; \
		echo "  - Automatically include bookmarks in search をオフ"; \
		echo "  - Apply changes"; \
		echo ""; \
		echo "■ One Tab"; \
		echo "  - URL display:"; \
		echo "      Abbreviated"; \
		echo "  - Automatic action when clicking to open a tab:"; \
		echo "      Open the tab, and move it to trash"; \
		echo "  - Automatic action when clicking to open a group of tabs:"; \
		echo "      Open the tabs, and move the group to trash"; \
		echo "  - Right-click inside a web page to access the OneTab context menu:"; \
		echo "      Disabled"; \
		echo ""; \
		echo "■ The Marvellous Suspender"; \
		echo "  - Automatic tab suspension"; \
		echo "      Automatically suspend tabs after: 1 hour"; \
		echo "      Never suspend pinned tabs (チェック)"; \
		echo "      Never suspend tabs that contain unsaved form inputs (チェック)"; \
		echo "      Never suspend tabs that are playing audio (チェック)"; \
		echo "      Never suspend active tab in each window: オフ"; \
		echo "  - Suspended tabs"; \
		echo "      Automatically unsuspend tab when it is viewed (チェック)"; \
		echo "      Apply Chrome's built-in memory-saving when suspending (チェック)"; \
		echo "      Screen capturing: Capture top of screen only"; \
		echo "  - Other"; \
		echo "      Add The Marvellous Suspender to right-click context menu: オフ"; \
		echo "      Sync settings with your Chrome profile: on"; \
		echo ""; \
		echo "■ Tampermonkey"; \
		echo "  - Config mode: Advanced"; \
		echo "  - Userscript Sync: Dropboxを有効化"; \
		echo ""; \
		echo "設定ページを開きます..."; \
		echo ""; \
		open -a "Google Chrome" "chrome-extension://aapbdbdomjkkjkaonfhkkikfgjllcleb/options.html"; \
		open -a "Google Chrome" "chrome-extension://fdpohaocaechififmbbbbbknoalclacl/options.html"; \
		open -a "Google Chrome" "chrome-extension://jnjfeinjfmenlddahdjdmgpbokiacbbb/options.html"; \
		open -a "Google Chrome" "chrome-extension://chphlpgkkbolifaimnlloiipkdnihall/options.html"; \
		open -a "Google Chrome" "chrome-extension://noogafoofpebimajpfpamcfhoaifemoa/options.html"; \
		open -a "Google Chrome" "chrome-extension://dhdgffkkebhmkfjojejmpbldmpobfkfo/options.html#nav=settings"; \
		echo ""; \
		echo "全ての設定ページを開きました"; \
	else \
		echo "詳細設定をスキップしました"; \
	fi

disk-usage: ## ディスク使用状況を表示
	@echo "=== ディスク使用状況 ==="
	df -h /

clean-cache: ## 全てのキャッシュをクリーンアップ
	@echo "=== 全てのキャッシュをクリーンアップします ==="
	@echo ""
	@echo "Homebrewキャッシュをクリーンアップ中..."
	-brew cleanup -s
	@echo ""
	@echo "npmキャッシュをクリーンアップ中..."
	-npm cache clean --force
	@echo "yarnキャッシュをクリーンアップ中..."
	-yarn cache clean
	@echo ""
	@echo "pipキャッシュをクリーンアップ中..."
	-pip cache purge
	-pip3 cache purge
	@echo ""
	@echo "Composerキャッシュをクリーンアップ中..."
	-composer clear-cache
	@echo ""
	@echo "Ruby gemキャッシュをクリーンアップ中..."
	-gem cleanup
	@echo ""
	@echo "Dockerキャッシュをクリーンアップ中..."
	-docker system prune -af --volumes
	@echo ""
	@echo "Xcodeキャッシュをクリーンアップ中..."
	-rm -rf ~/Library/Developer/Xcode/DerivedData/*
	@echo ""
	@echo "macOSシステムキャッシュをクリーンアップ中..."
	-find ~/Library/Caches -type f -atime +30 -delete
	@echo ""
	@echo "=== クリーンアップ完了 ==="
	@echo ""
	@make disk-usage
