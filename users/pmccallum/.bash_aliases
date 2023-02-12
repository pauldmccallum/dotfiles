
# Random Aliases
alias vim='nvim'
alias vi='nvim'
alias cfb='nvim ~/.bashrc'
alias cfz='nvim ~/.zshrc'
alias cfba='nvim ~/.bash_aliases'
alias cfc='sudo nvim /etc/nixos/configuration.nix'
alias cfh='nvim ~/.config/nixpkgs/home.nix'
alias cfi3='nvim ~/.config/i3/config'
alias cft='nvim ~/.tmux.conf'
alias sb='source ~/.bashrc'

# Nixos Aliases
alias set-default-boot='/run/current-system/bin/switch-to-configuration boot'
alias full-system-clean='nix-collect-garbage -d && sudo nix-collect-garbage -d'
alias full-system-upgrade="sudo nixos-rebuild switch --upgrade && flatpak update -y && nix-env -u '*'"
alias list-system-configurations='ls -l /nix/var/nix/profiles/system-*-link'
alias system-rebuild='sudo nixos-rebuild switch'
alias system-repair='sudo nixos-rebuild switch --repair'
alias full-system-repair='nix-store --verify --check-contents --repair'
alias system-upgrade-information='sudo nixos-rebuild switch --upgrade dry-build'
alias local-upgrade="nix-channel --update nixpkgs && nix-env -u '*'"

