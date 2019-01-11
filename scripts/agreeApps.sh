#!/bin/sh

array=(
    # brew cask
    "/Applications/Docker.app"
    "/Applications/Sublime Text.app"
    "/Applications/MacDown.app"
    "/Applications/Alfred 3.app"
    "/Applications/Dropbox.app"
    "/Applications/Karabiner-Elements.app"
    "/Applications/Google Chrome.app"
    "/Applications/Firefox.app"
    "/Applications/MySQLWorkbench.app"
    "/Applications/Skitch.app"
    "/Applications/Evernote.app"
    "/Applications/Charles.app"
    "/Applications/Clipy.app"
    "/Applications/HandBrake.app"
    "/Applications/Language Switcher.app"
    "/Applications/Sequel Pro.app"
    "/Applications/iTerm.app"
    "/Applications/GoogleJapaneseInput.localized/ConfigDialog.app"
    "/Applications/Backup and Sync.app"

    # adobe ha installer
    "/usr/local/Caskroom/adobe-creative-cloud/latest/Creative Cloud Installer.app"

    # mac標準
    "/Applications/iTunes.app"
    "/Applications/App Store.app"
    "/Applications/Books.app"
    "/Applications/Calendar.app"
    "/Applications/Contacts.app"
    "/Applications/Notes.app"
    "/Applications/Photos.app"
    "/Applications/Safari.app"
    "/Applications/VoiceMemos.app"

    # mas = mac app store
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
    "/Applications/Tweetbot.app"
    "/Applications/Xcode.app"
    "/Applications/iMovie.app"

    # are?
#    "/Applications/Twitter.app"

    # 手動？
    "/Applications/FileZilla.app"
    "/Applications/Picasa.app"
    "/Applications/RICOH THETA.app"

    # font
    "~/Dropbox/Fonts/SourceCodePro-Reguslar-Powerline.otf"


    # "/Applications/"
    # "/Applications/"
    # "/Applications/"
    # "/Applications/"
    # "/Applications/"
    # "/Applications/"
    # "/Applications/"


# Adobe Lightroom Classic CC/
# Adobe Photoshop CC 2018/
# Adobe XD CC/
# Automator.app/
# Backup and Sync.app/
# Box Sync.app/
# FaceTime.app/

# Font Book.app/
# GlobalProtect.app/
# Gyazo.app/

# Microsoft Excel.app/
# Microsoft OneNote.app/
# Microsoft Outlook.app/
# Microsoft PowerPoint.app/
# Microsoft Word.app/
# QBlocker.app/

# ShareMouse.app/

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
