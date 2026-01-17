#!/bin/sh

# アプリを起動して初期設定・権限ダイアログを済ませる
# Bartenderなどアプリ監視ツールにすべて拾ってもらうためにも使用
#
# アクセス許可を出させたり初回起動をどうしてもやりたいもののみに絞ろう。
# SSH_CLIENTみてmac上でかどうか判定、、でも、それならリモートで入れる、あとで端末で同意、とかができないし、、

# brew caskでインストールしたアプリ
brew_cask_apps=(
    "/Applications/Docker.app"
    "/Applications/Sublime Text.app"
    "/Applications/MacDown.app"   # arm macだとエラーになるので一度右クリックで開く
    "/Applications/Alfred 4.app"
    "/Applications/Alfred 5.app"
    "/Applications/Dropbox.app"
    "/Applications/Karabiner-Elements.app"
    "/Applications/Google Chrome.app"
    "/Applications/Firefox.app"
    "/Applications/MySQLWorkbench.app"
    "/Applications/GoogleJapaneseInput.localized/ConfigDialog.app"
    "/Applications/iTerm.app"
    "/Applications/Charles.app"
    "/Applications/Clipy.app"
    "/Applications/HandBrake.app"
    "/Applications/Adobe Creative Cloud/Adobe Creative Cloud.app"
    "/usr/local/Caskroom/adobe-creative-cloud/latest/Creative Cloud Installer.app"
    "/Applications/Google Drive.app"
#    "/Applications/Backup and Sync.app"
#    "/Applications/Gyazo.app"
    "/Applications/Notion.app"
    "/Applications/Notion Calendar.app"
    "/Applications/Chatwork.app"
#    "/Applications/ShareMouse.app"
#    "/Applications/Sequel Pro.app"
    "/Applications/Sequel Ace.app"
#    "/Applications/Box Sync.app"
    "/Applications/Box.app"
    "/Applications/draw.io.app"
    "/Applications/zoom.us.app"
    "/Applications/PhpStorm.app"
    "/Applications/AltTab.app"
    "/Applications/Logi Options+.app"
    "/Applications/Bartender 4.app"
    "/Applications/Bartender 5.app"
    "/Applications/Bartender 6.app"
    "/Applications/volumeHUD.app"
)

# masでインストールしたアプリ
mas_apps=(
    "/Applications/Kindle.app"
    "/Applications/Evernote.app"
    "/Applications/iMovie.app"
    "/Applications/Keynote.app"
    "/Applications/Pages.app"
    "/Applications/Numbers.app"
    "/Applications/BetterSnapTool.app"
    "/Applications/The Unarchiver.app"
    "/Applications/Skitch.app"
    "/Applications/Integrity.app"
    "/Applications/LINE.app"
    "/Applications/Photos Duplicate Cleaner.app"
    "/Applications/Slack.app"
    "/Applications/OneDrive.app"
    "/Applications/Microsoft Remote Desktop.app"
    "/Applications/Microsoft Excel.app"
    "/Applications/Microsoft Word.app"
    "/Applications/Microsoft PowerPoint.app"
    "/Applications/Amphetamine.app"
    "/Applications/RunCat.app"
    "/Applications/AmorphousDiskMark.app"
)

# macOS標準アプリ
system_apps=(
    "/System/Applications/Music.app"
    "/Applications/App Store.app"
    "/System/Applications/App Store.app"
    "/System/Applications/Books.app"
    "/System/Applications/Calendar.app"
    "/System/Applications/Contacts.app"
    "/System/Applications/Notes.app"
    "/System/Applications/Photos.app"
    "/Applications/Safari.app"
    "/System/Applications/VoiceMemos.app"
    "/System/Applications/Reminders.app"
)

# 手動インストールアプリ
manual_apps=(
    "/Applications/FileZilla.app"
    # https://filezilla-project.org/download.php?type=client
    "/Applications/Picasa.app"
    "/Applications/RICOH THETA.app"
    # https://support.theta360.com/ja/download/pcmac/
)

# Adobe Lightroom Classic CC/
# Adobe Photoshop CC 2018/
# Adobe XD CC/
# Automator.app/
# FaceTime.app/

# なくなった mas アプリ
# MPlayerX
# QREncoder
# Clear
# Pocket
# Reeder
# Tweetbot

# QBlocker.app/  # あれ？もう不要？

# 存在するアプリのみフィルタして表示
show_apps() {
    local -n apps=$1
    local count=0
    for app in "${apps[@]}"; do
        if [ -e "$app" ]; then
            echo "  - $(basename "$app" .app)"
            ((count++))
        fi
    done
    echo ""
    echo "  （${count}個のアプリが見つかりました）"
}

# 存在するアプリを開く
open_apps() {
    local -n apps=$1
    for app in "${apps[@]}"; do
        if [ -e "$app" ]; then
            echo "起動: $(basename "$app" .app)"
            open "$app"
            sleep 0.5
        fi
    done
}

echo "========================================"
echo "アプリ起動ツール"
echo "========================================"
echo ""
echo "目的："
echo "  - 初期設定・権限ダイアログを済ませる"
echo "  - Bartenderなどにアプリを認識させる"
echo ""

# brew caskアプリ
echo "========================================"
echo "【1/4】brew caskでインストールしたアプリ"
echo "========================================"
echo ""
show_apps brew_cask_apps
echo ""
read -p "これらのアプリを開きますか？ (y/N): " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    open_apps brew_cask_apps
    echo ""
    read -p "続けるにはEnterを押してください..." dummy
fi

# masアプリ
echo ""
echo "========================================"
echo "【2/4】mas（Mac App Store）でインストールしたアプリ"
echo "========================================"
echo ""
show_apps mas_apps
echo ""
read -p "これらのアプリを開きますか？ (y/N): " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    open_apps mas_apps
    echo ""
    read -p "続けるにはEnterを押してください..." dummy
fi

# macOS標準アプリ
echo ""
echo "========================================"
echo "【3/4】macOS標準アプリ"
echo "========================================"
echo ""
show_apps system_apps
echo ""
read -p "これらのアプリを開きますか？ (y/N): " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    open_apps system_apps
    echo ""
    read -p "続けるにはEnterを押してください..." dummy
fi

# 手動インストールアプリ
echo ""
echo "========================================"
echo "【4/4】手動インストールしたアプリ"
echo "========================================"
echo ""
show_apps manual_apps
echo ""
read -p "これらのアプリを開きますか？ (y/N): " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    open_apps manual_apps
fi

echo ""
echo "========================================"
echo "完了"
echo "========================================"
echo ""
echo "各アプリの権限ダイアログを確認してください"
echo ""

# 全部開いてダイアログでagreeを @todo; agreeないのだけにしたい
