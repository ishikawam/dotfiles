#!/bin/bash

brew update
brew upgrade nodenv
versions=($(nodenv install -l | grep -o "^[0-9]*" | sort -n | uniq))

#echo latest LTS
#nvm ls-remote --lts | grep "Latest"

echo latest each versions
for v in "${versions[@]}"
do
    nodenv install -l | grep "^$v\." | sort -n | tail -1
done
