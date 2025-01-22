alias kf="open -a Finder ./"
export EDITOR=nvim
set -o vi
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
export PATH=/opt/homebrew/bin:/Users/Shared/opt/bin:$PATH:/Users/dirichy/Library/Python/3.9/bin
eval "$(zoxide init zsh)"
for i in ~/.config/profile/*.sh; do
  source $i
done
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fzf --zsh | eval
. "$HOME/.cargo/env"
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
alias sshfsnas="sshfs -o follow_symlinks ldirichy:/home/dirichy /Users/dirichy/ldirichy"
alias jup="jupyter notebook"
chruby ruby-3.3.5
