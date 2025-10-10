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
	if [ -f ~/private/scripts/setup_private.sh ]; then bash ~/private/scripts/setup_private.sh ; fi

setup-private: ## プライベート設定のセットアップ
	bash ~/private/scripts/setup_private.sh

install: ## setupのエイリアス
	make setup

gitignore_checker: ## gitignoreをチェッカーモードに切り替え
	ln -sf ~/.gitignore_checker ~/.gitignore

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
