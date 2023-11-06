#!/bin/sh

# アクセス許可を出させたり初回起動をどうしてもやりたいもののみに絞ろう。
# SSH_CLIENTみてmac上でかどうか判定、、でも、それならリモートで入れる、あとで端末で同意、とかができないし、、

array=(
    # brew cask
    "/Applications/Docker.app"
    "/Applications/Sublime Text.app"
    "/Applications/MacDown.app"   # arm macだとエラーになるので一度右クリックで開く
    "/Applications/Alfred 4.app"
    "/Applications/Dropbox.app"
    "/Applications/Karabiner-Elements.app"
    "/Applications/Google Chrome.app"
    "/Applications/Firefox.app"
    "/Applications/MySQLWorkbench.app"
    "/Applications/Skitch.app"
    "/Applications/Evernote.app"  # でも当分はEvernote Legacy
    "/Applications/Charles.app"
    "/Applications/Clipy.app"
    "/Applications/HandBrake.app"
    "/Applications/Sequel Ace.app"
#    "/Applications/Sequel Pro.app"
    "/Applications/iTerm.app"
    "/Applications/GoogleJapaneseInput.localized/ConfigDialog.app"
    "/Applications/Google Drive.app"
#    "/Applications/Backup and Sync.app"
    "/Applications/Gyazo.app"
    "/Applications/Box.app"
#    "/Applications/Box Sync.app"
#    "/Applications/ShareMouse.app"
    "/Applications/PhpStorm.app"
    "/Applications/Notion.app"
    "/Applications/logioptionsplus.app"

    # adobe は installer
    "/usr/local/Caskroom/adobe-creative-cloud/latest/Creative Cloud Installer.app"

    # mac標準
    "/System/Applications/Music.app"
    "/Applications/App Store.app"
    "/System/Applications/App\ Store.app"
    "/System/Applications/Books.app"
    "/System/Applications/Calendar.app"
    "/System/Applications/Contacts.app"
    "/System/Applications/Notes.app"
    "/System/Applications/Photos.app"
    "/Applications/Safari.app"
    "/System/Applications/VoiceMemos.app"
    "/System/Applications/Reminders.app"

    # mas = mac app store
    "/Applications/Adobe\ Creative\ Cloud/Adobe\ Creative\ Cloud"
    "/Applications/BetterSnapTool.app"
    "/Applications/Clear.app"
    "/Applications/Keynote.app"
    "/Applications/Kindle.app"
    "/Applications/LINE.app"
    "/Applications/MPlayerX.app"
    "/Applications/Numbers.app"
    "/Applications/OneDrive.app"
    "/Applications/Pages.app"
    "/Applications/Photos Duplicate Cleaner.app"
    "/Applications/QREncoder.app"
    "/Applications/Reeder.app"
    "/Applications/Slack.app"
#    "/Applications/Tweetbot.app"
    "/Applications/Xcode.app"
    "/Applications/iMovie.app"

    # 手動
    "/Applications/FileZilla.app"
    # https://filezilla-project.org/download.php?type=client
    "/Applications/Picasa.app"
    "/Applications/RICOH THETA.app"
    # https://support.theta360.com/ja/download/pcmac/


# Adobe Lightroom Classic CC/
# Adobe Photoshop CC 2018/
# Adobe XD CC/
# Automator.app/
# FaceTime.app/


# Microsoft Excel.app/
# Microsoft OneNote.app/
# Microsoft Outlook.app/
# Microsoft PowerPoint.app/
# Microsoft Word.app/

# QBlocker.app/  # あれ？もう不要？


)

for i in "${array[@]}"
do
    read -p "Open app \"$i\"  y or n (n): " ans
    if [ "$ans" = "y" ]; then
        open "$i"
    fi
done

# 途中karabiner-elementsでFumihiko Takayamaを許可するかどうか出てくるので許可を。
# 全部開いてダイアログでagreeを @todo; agreeないのだけにしたい
