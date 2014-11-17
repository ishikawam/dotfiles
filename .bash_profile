## users generic .bash_profil file for mac, fedora, and any linux.
## @author: M.Ishikawa

# .bashrcを読み込むように。
if [ -f ~/.bashrc ] ; then
	. ~/.bashrc
fi


##
# Your previous /Users/masayuki.ishikawa/.bash_profile file was backed up as /Users/masayuki.ishikawa/.bash_profile.macports-saved_2012-08-22_at_21:56:43
##

# MacPorts Installer addition on 2012-08-22_at_21:56:43: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # This loads NVM
