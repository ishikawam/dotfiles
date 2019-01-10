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

    # mac標準
    "/Applications/iTunes.app"
    "/Applications/App Store.app"
    "/Applications/Books.app"
    "/Applications/Calendar.app"
    "/Applications/Contacts.app"

    # mas = mac app store
    "/Applications/BetterSnapTool.app"
    "/Applications/Clear.app"
    "/Applications/Keynote.app"
    "/Applications/Kindle.app"
    "/Applications/LINE.app"

    # 手動？
    "/Applications/FileZilla.app"


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
# GoogleJapaneseInput.localized/
# Gyazo.app/

# Language Switcher.app/
# Launchpad.app/
# LimeChat.app/
# LiveReload.app/
# Logi Options.app/
# Logic Pro X.app/
# MPlayerX.app/
# MacDown.app/
# Mail.app/
# Maps.app/
# Messages.app/
# Microsoft Excel.app/
# Microsoft OneNote.app/
# Microsoft Outlook.app/
# Microsoft PowerPoint.app/
# Microsoft Word.app/
# Mission Control.app/
# MySQLWorkbench.app/
# News.app/
# Notes.app/
# Numbers.app/
# OneDrive.app/
# Pages.app/
# Photo Booth.app/
# Photos Duplicate Cleaner.app/
# Photos.app/
# Picasa Web Albums Uploader.app/
# Picasa.app/
# Preview.app/
# QBlocker.app/
# QREncoder.app/
# QuickTime Player.app/
# RICOH THETA.app/
# Reeder.app/
# Reminders.app/
# Safari.app/
# Self Service.app/
# Sequel Pro.app/
# ShareMouse.app/
# Siri.app/
# Skitch.app/
# Slack.app/
# Stickies.app/
# Stocks.app/
# Sublime Text.app/
# Symantec Solutions/
# System Preferences.app/
# TextEdit.app/
# The Unarchiver.app/
# Time Machine.app/
# Tweetbot.app/
# Twitter.app/
# Utilities/
# VirtualBox.app/
# VoiceMemos.app/
# Xcode.appdownload/
# Xcode1010.app/
# greppy.app/
# iMovie.app/
# iTerm.app/
# 

)

for i in "${array[@]}"
do
    read -p "Open app \"$i\"  y or n (n): " ans

    if [ "$ans" = "y" ]; then
        open "$i"
    fi

done





exit

# 途中karabiner-elementsでFumihiko Takayamaを許可するかどうか出てくるので許可を。
# 全部開いてダイアログでagreeを @todo; agreeないのだけにしたい


