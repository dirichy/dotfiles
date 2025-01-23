autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST
PROMPT='%F{green}$(whoami)%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f%F{red}$%f '

alias kf="open -a Finder ./"
export EDITOR=nvim
set -o vi
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
export PATH=/opt/homebrew/bin:/Users/Shared/opt/bin:$PATH:/Users/dirichy/Library/Python/3.9/bin
eval "$(zoxide init zsh)"
for i in ~/.config/profile/*.sh; do
  source $i
done
for i in ~/.config/profile/*.zsh; do
  source $i
done
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fzf --zsh | eval
. "$HOME/.cargo/env"
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
alias sshfsnas="sshfs -o follow_symlinks ldirichy:/home/dirichy /Users/dirichy/ldirichy"
chruby ruby-3.3.5
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
