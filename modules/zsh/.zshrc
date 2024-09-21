# Keybindings
# bindkey -e
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
# bindkey '^[w' kill-region

# History
HISTSIZE=500000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Handy change dir shortcuts

# Nix related
# alias scg ='sudo nix-collect-garbage -d'
# alias rb ='sudo nixos-rebuild switch --flake ~/rudra#default'
# alias upd ='sudo nix flake update ~/rudra'
# alias upg ='sudo nixos-rebuild switch --upgrade --flake ~/rudra#default'

# Core Utils Aliases
# alias l='eza -lh  --icons=auto'
# alias ls='eza -1   --icons=auto' # short list
# alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
# alias ld='eza -lhD --icons=auto' # long list dirs
# aliao ssh='kitten ssh'
# alias tree='tree -a -I .git'
# alias cat='bat'
alias c='clear' # clear terminal
# alias e='exit'
alias mkdir='mkdir -p'
alias v='vim'
# alias grep='rg --color=auto'
alias ssn='sudo shutdown now'
alias srn='sudo reboot now'

# Git Aliases
# alias gac='git add . && git commit -m'
# alias gs='git status'
# alias gpush='git push origin'
alias lg='lazygit'

# Downloads Aliases
# alias yd='yt-dlp -f "bestvideo+bestaudio" --embed-chapters --external-downloader aria2c --concurrent-fragments 8 --throttled-rate 100K'
# alias td='yt-dlp --external-downloader aria2c -o "%(title)s."'
# alias download='aria2c --split=16 --max-connection-per-server=16 --timeout=600 --max-download-limit=10M --file-allocation=none'

# VPN Aliases
# alias vpn-up='sudo tailscale up --exit-node=raspberrypi --accept-routes'
# alias vpn-down='sudo tailscale down'
# warp ()
# {
#     sudo systemctl "$1" warp-svc
# }

# Other Aliases
# alias apps-space='expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqe | sort) <(pacman -Qqg base base-devel | sort)) | sort -n'
# alias files-space='sudo ncdu --exclude /.snapshots /'
# alias ld='lazydocker'
alias docker-clean='docker container prune -f && docker image prune -f && docker network prune -f && docker volume prune -f'
# alias crdown='mpv --yt-dlp-raw-options=cookies-from-browser=brave'
# alias cr='cargo run'
# alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT1'
# alias y='yazi'

# Wayland Clipboard Aliases `wl-clipboard`
alias pbcopy='wl-copy'
alias pbpaste='wl-paste'


# Shell Intergrations
# eval "$(fzf --zsh)"
# eval "$(zoxide init --cmd cd zsh)"
# eval "$(starship init zsh)"
# eval "$(fnm env --use-on-cd)"
