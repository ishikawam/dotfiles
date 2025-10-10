#!/bin/bash

# データ移行スクリプト
# 旧Macから新Macへのユーザーデータ移行を支援

set -e

# 色付き出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  データ移行ツール${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 前回の選択を読み込み（~/scripts/.migrate_data/に保存）
MIGRATE_DATA_DIR="$HOME/scripts/.migrate_data"
mkdir -p "$MIGRATE_DATA_DIR"
LAST_VOLUME_FILE="$MIGRATE_DATA_DIR/last_volume"
LAST_USER_FILE="$MIGRATE_DATA_DIR/last_user"
last_volume_num=""
last_user_num=""
if [ -f "$LAST_VOLUME_FILE" ]; then
    last_volume_num=$(cat "$LAST_VOLUME_FILE" | tr -d '\n')
fi
if [ -f "$LAST_USER_FILE" ]; then
    last_user_num=$(cat "$LAST_USER_FILE" | tr -d '\n')
fi

# 移行元の選択
echo -e "${GREEN}Step 1: 移行元ボリュームの選択${NC}"
echo ""
echo "利用可能なボリューム:"
ls -1d /Volumes/* 2>/dev/null | nl
echo ""

if [ -n "$last_volume_num" ]; then
    read -p "移行元ボリュームの番号を入力してください ($last_volume_num): " volume_num
else
    read -p "移行元ボリュームの番号を入力してください: " volume_num
fi

# 入力がなければ前回の番号を使用
if [ -z "$volume_num" ]; then
    if [ -n "$last_volume_num" ]; then
        volume_num="$last_volume_num"
        echo -e "${YELLOW}前回と同じボリュームを使用: 番号 $volume_num${NC}"
    else
        echo -e "${RED}エラー: ボリューム番号を入力してください${NC}"
        exit 1
    fi
fi

VOLUME_PATH=$(ls -1d /Volumes/* 2>/dev/null | sed -n "${volume_num}p")

if [ -z "$VOLUME_PATH" ]; then
    echo -e "${RED}エラー: 無効な選択です${NC}"
    exit 1
fi

# 選択した番号を記録
echo "$volume_num" > "$LAST_VOLUME_FILE"

echo -e "${YELLOW}選択されたボリューム: $VOLUME_PATH${NC}"
echo ""

# ユーザーディレクトリの選択
echo -e "${GREEN}Step 2: 移行元ユーザーディレクトリの選択${NC}"
echo ""

# /Volumes/*/Users/ 配下のディレクトリを探す
USER_BASE="$VOLUME_PATH/Users"
if [ ! -d "$USER_BASE" ]; then
    echo -e "${RED}エラー: $USER_BASE が見つかりません${NC}"
    exit 1
fi

echo "ユーザーディレクトリを検索中..."
echo ""

# アクセス可能なディレクトリのみを抽出
accessible_dirs=()
counter=1

for dir in "$USER_BASE"/*; do
    if [ -d "$dir" ]; then
        dir_name=$(basename "$dir")

        # シンボリックリンクは除外
        if [ -L "$dir" ]; then
            echo -e "    ${YELLOW}スキップ: $dir_name${NC} (シンボリックリンク)"
            continue
        fi

        # Sharedは除外
        if [ "$dir_name" = "Shared" ]; then
            echo -e "    ${YELLOW}スキップ: $dir_name${NC}"
            continue
        fi

        # 読み取り権限チェック
        if [ -r "$dir" ] && [ -x "$dir" ]; then
            accessible_dirs+=("$dir")
            printf "%2d  %s\n" "$counter" "$dir_name"
            counter=$((counter + 1))
        else
            echo -e "    ${RED}アクセス不可: $dir_name${NC}"
        fi
    fi
done

echo ""

if [ ${#accessible_dirs[@]} -eq 0 ]; then
    echo -e "${RED}エラー: アクセス可能なユーザーディレクトリが見つかりません${NC}"
    exit 1
fi

if [ -n "$last_user_num" ]; then
    read -p "移行元ユーザーの番号を入力してください ($last_user_num): " user_num
else
    read -p "移行元ユーザーの番号を入力してください: " user_num
fi

# 入力がなければ前回の番号を使用
if [ -z "$user_num" ]; then
    if [ -n "$last_user_num" ]; then
        user_num="$last_user_num"
        echo -e "${YELLOW}前回と同じユーザーを使用: 番号 $user_num${NC}"
    else
        echo -e "${RED}エラー: ユーザー番号を入力してください${NC}"
        exit 1
    fi
fi

if [ "$user_num" -ge 1 ] && [ "$user_num" -le ${#accessible_dirs[@]} ]; then
    SOURCE_DIR="${accessible_dirs[$((user_num - 1))]}"
    # 選択した番号を記録
    echo "$user_num" > "$LAST_USER_FILE"
else
    echo -e "${RED}エラー: 無効な番号です${NC}"
    exit 1
fi

if [ -z "$SOURCE_DIR" ] || [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}エラー: 無効なディレクトリです${NC}"
    exit 1
fi

# 最終的なアクセス確認
if [ ! -r "$SOURCE_DIR" ] || [ ! -x "$SOURCE_DIR" ]; then
    echo -e "${RED}エラー: $SOURCE_DIR への読み取り権限がありません${NC}"
    exit 1
fi

echo -e "${YELLOW}移行元: $SOURCE_DIR${NC}"
echo ""

# 移行先ディレクトリ名の入力
echo -e "${GREEN}Step 3: 移行先ディレクトリの設定${NC}"
echo ""
echo "移行先は ~/tmp/ 配下に作成されます"
echo ""

# ~/tmp/の既存ディレクトリを表示
echo "~/tmp/ の既存ディレクトリ:"
if ls -1d "$HOME/tmp"/*/ 2>/dev/null | grep -q .; then
    ls -1d "$HOME/tmp"/*/ 2>/dev/null | while read dir; do
        dir_name=$(basename "$dir")
        echo "  - $dir_name"
    done
else
    echo "  (なし)"
fi
echo ""

# 前回使用した名前を読み込み（~/scripts/.migrate_data/に保存）
LAST_DEST_FILE="$MIGRATE_DATA_DIR/last"
last_dest_name=""
if [ -f "$LAST_DEST_FILE" ]; then
    last_dest_name=$(cat "$LAST_DEST_FILE" | tr -d '\n')
fi

# プロンプトの作成
if [ -n "$last_dest_name" ]; then
    prompt_text="移行先ディレクトリ名を入力してください（前回: ${last_dest_name}）: "
    read -p "$prompt_text" dest_name
else
    read -p "移行先ディレクトリ名を入力してください（例: old_mac_data）: " dest_name
fi

# 入力がなければ前回の名前またはデフォルト名を使用
if [ -z "$dest_name" ]; then
    if [ -n "$last_dest_name" ]; then
        dest_name="$last_dest_name"
        echo -e "${YELLOW}前回と同じ名前を使用: $dest_name${NC}"
    else
        # デフォルト名を生成
        dest_name="migration_$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}デフォルト名を使用: $dest_name${NC}"
    fi
fi

DEST_DIR="$HOME/tmp/$dest_name"

# 使用した名前を記録
echo "$dest_name" > "$LAST_DEST_FILE"

# 移行先ディレクトリの作成
mkdir -p "$DEST_DIR"
echo -e "${YELLOW}移行先: $DEST_DIR${NC}"
echo ""

# 確認
echo -e "${GREEN}Step 4: 最終確認${NC}"
echo ""
echo -e "${YELLOW}移行元:${NC} $SOURCE_DIR"
echo -e "${YELLOW}移行先:${NC} $DEST_DIR"
RSYNC_IGNORE="$HOME/scripts/.rsyncignore"
if [ -f "$RSYNC_IGNORE" ]; then
    echo -e "${YELLOW}除外設定:${NC} $RSYNC_IGNORE を使用"
fi
echo ""
read -p "この設定で移行を開始しますか？ (y/N): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo -e "${RED}キャンセルされました${NC}"
    exit 0
fi

# rsyncコマンドの実行
echo ""
echo -e "${GREEN}移行を開始します...${NC}"
echo ""

# ログファイルの設定
LOG_DIR="$MIGRATE_DATA_DIR/logs"
mkdir -p "$LOG_DIR"

# 古いログファイルを削除（5個以上あれば古い方から削除）
ls -1t "$LOG_DIR"/migrate_*.log 2>/dev/null | tail -n +5 | xargs rm -f 2>/dev/null || true

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/migrate_${TIMESTAMP}.log"

RSYNC_CMD="rsync -aEHX --info=progress2 --inplace"

if [ -f "$RSYNC_IGNORE" ]; then
    RSYNC_CMD="$RSYNC_CMD --exclude-from=$RSYNC_IGNORE"
fi

# 末尾のスラッシュを確保（rsyncの仕様）
SOURCE_DIR="${SOURCE_DIR%/}/"
DEST_DIR="${DEST_DIR%/}/"

echo -e "${BLUE}実行コマンド:${NC}"
echo "$RSYNC_CMD \"$SOURCE_DIR\" \"$DEST_DIR\""
echo ""
echo -e "${YELLOW}ログファイル:${NC} $LOG_FILE"
echo ""
echo -e "${BLUE}進捗表示中...（詳細はログファイルを参照）${NC}"
echo ""

# rsync実行
# 標準出力: 進捗を画面表示 + ログに全保存
set +e  # エラーでも継続
eval $RSYNC_CMD \"$SOURCE_DIR\" \"$DEST_DIR\" 2>&1 | tee "$LOG_FILE"
RSYNC_EXIT_CODE=${PIPESTATUS[0]}
set -e

echo ""

# エラーチェック
if [ $RSYNC_EXIT_CODE -ne 0 ]; then
    echo -e "${RED}========================================${NC}"
    echo -e "${RED}  警告: rsyncがエラーで終了しました${NC}"
    echo -e "${RED}========================================${NC}"
    echo ""
    echo -e "${YELLOW}終了コード:${NC} $RSYNC_EXIT_CODE"
    echo ""

    # ログからエラー行を抽出
    echo -e "${RED}最近のエラー（最大10件）:${NC}"
    grep -i "error\|failed\|cannot\|permission denied\|resource busy" "$LOG_FILE" | tail -10 || echo "  (エラー行が見つかりません)"
    echo ""
else
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  移行が完了しました！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
fi

echo -e "${YELLOW}移行元:${NC} $SOURCE_DIR"
echo -e "${YELLOW}移行先:${NC} $DEST_DIR"
echo ""
echo "確認コマンド:"
echo "  ls -lah \"$DEST_DIR\""
echo "  du -sh \"$DEST_DIR\""
echo ""
echo "ログ確認:"
echo "  cat \"$LOG_FILE\""
if [ $RSYNC_EXIT_CODE -ne 0 ]; then
    echo "  grep -i error \"$LOG_FILE\""
fi
