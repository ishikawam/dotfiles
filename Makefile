SHELL := /bin/bash

.DEFAULT_GOAL := help

# ヘルプ表示用マクロ
define print_help
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } \
		/^[a-zA-Z_-]+:.*?## / { printf "  \033[36m%-24s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""
endef

.PHONY: help
##@ ヘルプ
help: ## ヘルプを表示
	$(call print_help)

# フラグ管理用マクロ
define toggle_flag
	@test -f $(1) && echo "exists." || echo "not exists."
	$(2) $(1)
	@test -f $(1) && echo "exists." || echo "not exists."
endef

##@ セットアップ
setup: ## 初回セットアップ（Mac環境）
	bash ~/scripts/setup.sh
	bash ~/scripts/setup_mac.sh
#	make defaults  # 手動で
#	make agree-apps  # 手動で
	make setup-gh-hosts
	if [ -f ~/private/scripts/setup_private.sh ]; then bash ~/private/scripts/setup_private.sh ; fi

setup-private: ## プライベート設定のセットアップ
	bash ~/private/scripts/setup_private.sh

install: setup ## setupのエイリアス

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

##@ macOS設定
mas-list: ## Mac App Storeインストール済みアプリ一覧
	cat ~/private/installedtools/*/*/mas | sort -n | uniq

agree-apps: ## アプリの利用規約に同意
	yes | bash scripts/agreeApps.sh

record-installed-tools: ## インストール済みツールを記録
	bash ~/private/scripts/recordInstalledTools.sh

defaults: ## macOSのデフォルト設定を適用
	php scripts/defaults/defaults.php
	-php scripts/defaults/ini.php

defaults-dryrun: ## デフォルト設定をドライラン
	php scripts/defaults/defaults.php --dry-run

##@ Git操作
fetch: ## 全リポジトリをフェッチ
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

##@ 言語環境
ruby-install-latest: ## 最新のRubyをインストール
	rbenv install -s `rbenv install --list | grep "^ *[0-9.]*$$" | tail -1`
	rbenv global `rbenv install --list | grep "^ *[0-9.]*$$" | tail -1`
	sudo gem update --system
	sudo gem update

##@ クリーンアップ
clean: ## キャッシュと未使用Node.jsを削除
	$(MAKE) clean-cache
	$(MAKE) clean-unused-node

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
	-sudo gem cleanup
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

clean-unused-node: ## 未使用のNode.jsバージョンを削除
	@echo "=== 使用中のバージョン ===" && \
	GLOBAL_VER=$$(nodenv global) && \
	echo "global: $$GLOBAL_VER" && \
	echo "projects:" && \
	USED_VERS="" && \
	INVALID_FILES="" && \
	SEEN_VERS="" && \
	for f in $$(find ~/git -name ".node-version" 2>/dev/null | sort); do \
		content=$$(cat "$$f" | tr -d '\n\r') && \
		path=$$(dirname "$$f" | sed "s|$$HOME/git/||")/ && \
		if echo "$$content" | grep -qE '^v?[0-9]+\.[0-9]+\.[0-9]+$$'; then \
			ver=$$(echo "$$content" | sed 's/^v//') && \
			if ! echo "$$SEEN_VERS" | grep -qw "$$ver"; then \
				echo "  $$ver  \033[90m$$path\033[0m" && \
				SEEN_VERS="$$SEEN_VERS $$ver"; \
			fi && \
			USED_VERS="$$USED_VERS $$ver"; \
		elif echo "$$content" | grep -qE '^v?[0-9]+$$'; then \
			if ! echo "$$SEEN_VERS" | grep -qw "$$content"; then \
				echo "  $$content  \033[90m$$path\033[0m" && \
				SEEN_VERS="$$SEEN_VERS $$content"; \
			fi && \
			USED_VERS="$$USED_VERS $$content"; \
		else \
			INVALID_FILES="$$INVALID_FILES\n  \033[31m$$content\033[0m  \033[90m$$path\033[0m"; \
		fi; \
	done && \
	if [ -n "$$INVALID_FILES" ]; then \
		echo "" && \
		echo "=== 不正な.node-version ===" && \
		printf "$$INVALID_FILES\n"; \
	fi && \
	echo "" && \
	echo "=== 削除対象 ===" && \
	UNUSED="" && \
	for ver in $$(ls ~/.nodenv/versions 2>/dev/null); do \
		if [ "$$ver" != "$$GLOBAL_VER" ] && ! echo "$$USED_VERS" | grep -qw "$$ver"; then \
			size=$$(du -sh ~/.nodenv/versions/$$ver | cut -f1) && \
			echo "  $$ver ($$size)" && \
			UNUSED="$$UNUSED $$ver"; \
		fi; \
	done && \
	if [ -z "$$UNUSED" ]; then \
		echo "  なし" && \
		echo "" && \
		echo "削除対象がありません"; \
	else \
		echo "" && \
		read -p "これらを削除しますか？ (y/N): " answer && \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			for ver in $$UNUSED; do \
				echo "Removing $$ver..." && \
				rm -rf ~/.nodenv/versions/$$ver; \
			done && \
			echo "Done."; \
		else \
			echo "キャンセルしました"; \
		fi; \
	fi

##@ フラグ管理
set-dev: ## 開発用CLAUDE.mdシンボリックリンクを作成
	@test -L CLAUDE.md && echo "exists." || echo "not exists."
	ln -s dev/CLAUDE.md CLAUDE.md
	@test -L CLAUDE.md && echo "exists." || echo "not exists."

remove-dev: ## 開発用CLAUDE.mdシンボリックリンクを削除
	@test -L CLAUDE.md && echo "exists." || echo "not exists."
	rm -f CLAUDE.md
	@test -L CLAUDE.md && echo "exists." || echo "not exists."

set-ignore-sparse: ## private/installedtoolsを全て含めるモードに設定
	$(call toggle_flag,~/this/.ignore-sparse,touch)

remove-ignore-sparse: ## private/installedtoolsを自分のみ含めるモードに設定
	$(call toggle_flag,~/this/.ignore-sparse,rm -f)

set-force-defaults: ## defaultsを実行＆アップデートするモードに設定
	$(call toggle_flag,~/this/.force-defaults,touch)

remove-force-defaults: ## defaultsを実行＆アップデートしないモードに設定
	$(call toggle_flag,~/this/.force-defaults,rm -f)

##@ Claude Code
claude-improve-settings: ## 全プロジェクトから権限を収集しsettings.jsonを更新
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

##@ ユーティリティ
migrate-data: ## 対話式データ移行ツール
	bash scripts/migrate_data.sh

##@ アプリ設定
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
		echo "8/8: Tampermonkey（任意）"; \
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
	@echo "========================================"
	@echo "【各拡張機能の基本設定】chrome://extensions での設定"
	@echo "========================================"
	@echo ""
	@echo "以下の設定を行ってください："
	@echo ""
	@echo "■ Session Buddy"
	@echo "  - Allow in Incognito"
	@echo "  - Allow access to file URLs"
	@echo ""
	@echo "■ Google Translate"
	@echo "  - Allow in Incognito"
	@echo ""
	@echo "■ GoFullPage"
	@echo "  - Allow in Incognito"
	@echo ""
	@echo "■ JSONView"
	@echo "  - Allow in Incognito"
	@echo ""
	@echo "■ Quick Tabs"
	@echo "  - Allow in Incognito"
	@echo ""
	@read -p "設定ページを開きますか？ (y/N): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		open -a "Google Chrome" "chrome://extensions/?id=edacconmaakjimmfgnblocblbcdcpbko"; \
		open -a "Google Chrome" "chrome://extensions/?id=aapbdbdomjkkjkaonfhkkikfgjllcleb"; \
		open -a "Google Chrome" "chrome://extensions/?id=fdpohaocaechififmbbbbbknoalclacl"; \
		open -a "Google Chrome" "chrome://extensions/?id=chklaanhfefbnpoihckbnefhakgolnmc"; \
		open -a "Google Chrome" "chrome://extensions/?id=jnjfeinjfmenlddahdjdmgpbokiacbbb"; \
		echo ""; \
		read -p "基本設定画面を閉じてEnterキーを押してください..." dummy3; \
	fi
	@echo ""
	@echo "========================================"
	@echo "【拡張機能の詳細設定】"
	@echo "========================================"
	@echo ""
	@echo "以下の設定を行ってください："
	@echo ""
	@echo "■ Google Translate"
	@echo "  - 日本語に設定"
	@echo ""
	@echo "■ GoFullPage"
	@echo "  - Directory: GoFullPage（任意）"
	@echo "  - Auto-download files をチェック（任意）"
	@echo ""
	@echo "■ Quick Tabs"
	@echo "  - Perform RegEx Search"
	@echo "  - Always search URLs をオン"
	@echo "  - Automatically include bookmarks in search をオフ"
	@echo "  - Apply changes"
	@echo ""
	@echo "■ One Tab"
	@echo "  - URL display: Abbreviated（短縮表示）"
	@echo "  - Right-click inside a web page to access the OneTab context menu: Disabled（右クリックメニュー無効）"
	@echo ""
	@echo "■ The Marvellous Suspender"
	@echo "  - Automatic tab suspension"
	@echo "      Automatically suspend tabs after:（任意、1 hour 〜 3 days）"
	@echo "      Never suspend active tab in each window: オフ"
	@echo "  - Suspended tabs"
	@echo "      Automatically unsuspend tab when it is viewed (チェック)"
	@echo "      Apply Chrome's built-in memory-saving when suspending (チェック)"
	@echo "      Screen capturing: Capture top of screen only"
	@echo "  - Other"
	@echo "      Add The Marvellous Suspender to right-click context menu: オフ"
	@echo "      Sync settings with your Chrome profile: on"
	@echo ""
	@echo "■ Tampermonkey"
	@echo "  - Config mode: Advanced"
	@echo "  - Userscript Sync: Enable Userscript Sync, Dropbox, 'Run now', Save"
	@echo ""
	@read -p "設定ページを開きますか？ (y/N): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		open -a "Google Chrome" "chrome-extension://aapbdbdomjkkjkaonfhkkikfgjllcleb/options.html"; \
		open -a "Google Chrome" "chrome-extension://fdpohaocaechififmbbbbbknoalclacl/options.html"; \
		open -a "Google Chrome" "chrome-extension://jnjfeinjfmenlddahdjdmgpbokiacbbb/options.html"; \
		open -a "Google Chrome" "chrome-extension://chphlpgkkbolifaimnlloiipkdnihall/options.html"; \
		open -a "Google Chrome" "chrome-extension://noogafoofpebimajpfpamcfhoaifemoa/options.html"; \
		open -a "Google Chrome" "chrome-extension://dhdgffkkebhmkfjojejmpbldmpobfkfo/options.html#nav=settings"; \
		echo ""; \
		echo "全ての設定ページを開きました"; \
	fi

macos-manual-settings: ## macOSの手動設定をガイド
	@echo "========================================"
	@echo "【macOS 手動設定ガイド】"
	@echo "========================================"
	@echo ""
	@echo "make defaults で設定できない項目を順番に設定します"
	@echo ""
	@read -p "開始するにはEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Touch ID & Password"
	@echo "----------------------------------------"
	@echo "  - Touch IDを設定する"
	@echo "  - Apple Watch = オフ"
	@echo ""
	@open "x-apple.systempreferences:com.apple.Touch-ID-Settings"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Language & Region"
	@echo "----------------------------------------"
	@echo "  - First day of week = Monday"
	@echo "  - 英語をPrimaryに、日本語も追加"
	@echo ""
	@open "x-apple.systempreferences:com.apple.Localization-Settings.extension"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Keyboard > Keyboard Shortcuts > Mission Control"
	@echo "----------------------------------------"
	@echo "  ※ 左のリストから Mission Control を選択"
	@echo "  - Mission Control = F5"
	@echo "  - Application windows = F4"
	@echo "  - Show Desktop = F3"
	@echo ""
	@open "x-apple.systempreferences:com.apple.Keyboard-Settings.extension?Shortcuts"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Keyboard > Keyboard Shortcuts > Spotlight"
	@echo "----------------------------------------"
	@echo "  ※ 左のリストから Spotlight を選択"
	@echo "  - Show Apps = F2"
	@echo ""
	@open "x-apple.systempreferences:com.apple.Keyboard-Settings.extension?Shortcuts"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Menu Bar"
	@echo "----------------------------------------"
	@echo "  - Sound = オン"
	@echo "  - Spotlight = オフ"
	@echo "  - Time Machine = オン"
	@echo "  - Allow in the Menu Bar > LINE = オフ"
	@echo ""
	@open "x-apple.systempreferences:com.apple.ControlCenter-Settings"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Trackpad > Point & Click"
	@echo "----------------------------------------"
	@echo "  - Tap to click = オン"
	@echo ""
	@echo "■ Trackpad > More Gestures"
	@echo "  - Mission Control = Swipe Up with Four Fingers"
	@echo "  - App Exposé = Swipe Down with Four Fingers"
	@echo "  - Swipe between full-screen apps = Swipe Left or Right with Four Fingers"
	@echo ""
	@open "x-apple.systempreferences:com.apple.Trackpad-Settings"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Privacy & Security > Privacy > Full Disk Access"
	@echo "----------------------------------------"
	@echo "  - iTerm を追加"
	@echo ""
	@open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Desktop & Dock > Windows"
	@echo "----------------------------------------"
	@echo "  - Tiled windows have margins = オフ"
	@echo "  - 不要なアプリをDockから削除"
	@echo ""
	@open "x-apple.systempreferences:com.apple.Desktop-Settings"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Notifications"
	@echo "----------------------------------------"
	@echo "  - Allow notifications when the screen is locked = オフ"
	@echo "  - Allow notifications from iPhone = オフ"
	@echo "  - アプリ別: Show previews = Never"
	@echo "    - LINE, Reminders等"
	@echo "  - Music = 通知オフ"
	@echo ""
	@open "x-apple.systempreferences:com.apple.Notifications-Settings"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ Accessibility > Pointer Control > Trackpad Options"
	@echo "----------------------------------------"
	@echo "  ※ Trackpad Options... ボタンをクリック"
	@echo "  - Use trackpad for dragging = オン"
	@echo "  - Dragging style = Without Drag Lock"
	@echo ""
	@open "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?PointerControl"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "----------------------------------------"
	@echo "■ General > Sharing"
	@echo "----------------------------------------"
	@echo "  - コンピュータ名を設定"
	@echo ""
	@open "x-apple.systempreferences:com.apple.Sharing-Settings.extension"
	@read -p "設定画面を閉じてEnterキーを押してください..." dummy
	@echo ""
	@echo "========================================"
	@echo "全ての手動設定が完了しました"
	@echo "========================================"

##@ システム情報
disk-usage: ## ディスク使用状況を表示
	@echo "=== ディスク使用状況 ==="
	@echo ""
	@CONTAINER=$$(diskutil info / | awk '/APFS Container:/ {print $$3}') && \
	diskutil apfs list $$CONTAINER | awk ' \
		/Size \(Capacity Ceiling\):/ { total = $$4 / 1024 / 1024 / 1024 } \
		/Capacity In Use By Volumes:/ { \
			used = $$6 / 1024 / 1024 / 1024; \
			match($$0, /\([0-9.]+% used\)/); \
			used_pct = substr($$0, RSTART+1, RLENGTH-2); \
		} \
		/Capacity Not Allocated:/ { \
			free = $$4 / 1024 / 1024 / 1024; \
			match($$0, /\([0-9.]+% free\)/); \
			free_pct = substr($$0, RSTART+1, RLENGTH-2); \
		} \
		END { \
			printf "総容量:   %6.1f GB\n", total; \
			printf "使用中:   %6.1f GB  (%s)\n", used, used_pct; \
			printf "空き:     %6.1f GB  (%s)\n", free, free_pct; \
			print ""; \
			bar_width = 40; \
			used_blocks = int(used / total * bar_width); \
			printf "["; \
			for (i = 0; i < used_blocks; i++) printf "█"; \
			for (i = used_blocks; i < bar_width; i++) printf "░"; \
			printf "]\n"; \
		}' && \
	echo "" && \
	echo "--- ボリューム別 ---" && \
	diskutil apfs list $$CONTAINER | awk ' \
		/Name:/ { \
			match($$0, /Name:[[:space:]]+[^(]+/); \
			name = substr($$0, RSTART+5, RLENGTH-5); \
			gsub(/^[[:space:]]+|[[:space:]]+$$/, "", name); \
		} \
		/Capacity Consumed:/ { \
			match($$0, /[0-9]+ B/); \
			bytes = substr($$0, RSTART, RLENGTH-2); \
			size_gb = bytes / 1024 / 1024 / 1024; \
			printf "  %-14s %6.1f GB\n", name, size_gb; \
		}'

path: ## $PATHを見やすく表示
	@echo "$$PATH" | tr ':' '\n' | awk -F/ ' \
		{ \
			if ($$1 == ".") { \
				prefix = "./"; \
			} else { \
				prefix = "/" $$2 "/"; \
			} \
			items[prefix, ++count[prefix]] = $$0; \
			if (!seen[prefix]++) order[++n] = prefix; \
		} \
		END { \
			print "=== PATH ===\n"; \
			for (i=1; i<=n; i++) { \
				p = order[i]; \
				printf "\033[36m%s\033[0m\n", p; \
				for (j=1; j<=count[p]; j++) { \
					for (k=j+1; k<=count[p]; k++) { \
						if (items[p,j] > items[p,k]) { \
							tmp = items[p,j]; \
							items[p,j] = items[p,k]; \
							items[p,k] = tmp; \
						} \
					} \
				} \
				for (j=1; j<=count[p]; j++) { \
					printf "  %s\n", items[p,j]; \
				} \
				print ""; \
			} \
		}'
