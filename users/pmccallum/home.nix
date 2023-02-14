{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "pmccallum";
  home.homeDirectory = "/home/pmccallum";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  nixpkgs.config.allowUnfree = true;

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  systemd.user.services.wasabi-billing = {
      Unit = {
        Description = "Wasabi Billing script";
      };
      Service = {
        ExecStart = "/home/pmccallum/bin/wasabi-billing.sh";
      };
  };

  systemd.user.timers.wasabi-billing = {
    Timer = {
      OnCalendar = "*-*-* 09:56:00";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gnome-extension-manager
    gnome-menus
    papirus-icon-theme
    arc-icon-theme
    gnomeExtensions.arcmenu
    gnome.gnome-tweaks
    gnome.file-roller
    gnome.adwaita-icon-theme
    alacritty
    thunderbird
    _1password-gui
    microsoft-edge
    youtube-music
    rustdesk
    thonny
    qbittorrent
    crawlTiles
    discord
    plata-theme
    pcloud
    git-crypt
    gnupg
    pinentry-gnome
    protonup-ng
    lutris
    heroic
    onlyoffice-bin
    distrobox
    webkitgtk
    remmina
    pokerth
  ];

  home.file = {
    ".config/alacritty/alacritty.yaml".text = ''
     env:
       TERM: xterm-256color
     font:
       normal:
         family: monospace
	 style: Regular
       bold:
         family: monospace
         style: Bold
       italic:
         family: monospace
         style: Italic
       bold_italic:
         family: monospace
         style: Bold Italic
       size: 12.0

     windows_opacity: 1.0
    '';
  };
}
