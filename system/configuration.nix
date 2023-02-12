# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true; 

  programs.steam.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixie-lt"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Use the latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = ["amdgpu"];  

  # Set your time zone.
  time.timeZone = "America/Edmonton";
  time.hardwareClockInLocalTime = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-128n.psf.gz";
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";
      };

  # Enable the Desktop Environments
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;  
      layout = "us";  
      };
    };
    programs.dconf.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
  ]) ++ (with pkgs.gnome; [
      geary
      cheese
      gnome-music
      gnome-clocks
      epiphany
      gnome-weather
  ]);
  
  # Install system-wide Packages

    environment.systemPackages = (with pkgs; [
      gcc
      cmake
      python3Full
      wget
      unzip
      zip
      firefox
      git
      neovim
      curl
      steam
      steam-run
      cifs-utils
      restic
 ]);

  # Enable ZSH
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
  };

  # Enable Flatpak
  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;  

  # Enable Vulkan
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable OpenCL
  hardware.opengl.extraPackages = with pkgs; [
  rocm-opencl-icd
  rocm-opencl-runtime
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pmccallum = {
     isNormalUser = true;
     extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" ]; 
  };
  users.users.pmccallum.shell = pkgs.zsh;
   
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #};

  # List services that you want to enable:

  # Configure Restic Backup
  services.restic.backups = {
    remotebackup = {
      initialize = true;
      passwordFile = "/etc/nixos/secrets/restic-password";
      repository = "s3:https://s3.ca-central-1.wasabisys.com/nixosbackup";
      timerConfig = {
        OnUnitActiveSec = "1d";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 12"
        "--keep-yearly 3"
        ];
      extraBackupArgs = [
        "--include-file=/etc/nixos/restic-include"
        "--exclude-file=/etc/nixos/restic-exclude"
        ];
      extraOptions = [
      ];
      environmentFile = "/etc/nixos/secrets/s3credentials"; 
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  # ZRAM
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # Automate cleaning the Nix store
  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
  };

  # Enable compression for BTRFS
  fileSystems = {
    "/".options = [ "compress=zstd:1" "noatime" ];
    "/home".options = [ "compress=zstd:1" "noatime" ];
    "/var/log".options = [ "compress=zstd:1" "noatime" ];
    "/var/cache".options = [ "compress=zstd:1" "noatime" ];
    "/var/lib/libvirt/images".options = [ "compress=zstd:1" "noatime" ];
    "/.snapshots".options = [ "compress=zstd:1" "noatime" ];
};

  # Mount CIFS share from server
  fileSystems."/mnt/Backups" = {
      device = "//10.75.20.12/thecjester";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},vers=2.0,credentials=/etc/nixos/secrets/win-credentials,uid=1000,gid=1000"];
  };
}
