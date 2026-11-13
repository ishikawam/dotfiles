# Ubuntu の /etc/zsh/zshrc による compinit を抑止する。
# ~/.zshrc の compinit と fpath が異なるため、両方走ると ~/.zcompdump が毎回再生成される。
skip_global_compinit=1
