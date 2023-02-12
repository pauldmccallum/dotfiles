# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9927fdda-0636-4e8c-b757-159fa7035812";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/var/cache" =
    { device = "/dev/disk/by-uuid/9927fdda-0636-4e8c-b757-159fa7035812";
      fsType = "btrfs";
      options = [ "subvol=@cache" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/9927fdda-0636-4e8c-b757-159fa7035812";
      fsType = "btrfs";
      options = [ "subvol=@log" ];
    };

  fileSystems."/var/lib/libvirt/images" =
    { device = "/dev/disk/by-uuid/9927fdda-0636-4e8c-b757-159fa7035812";
      fsType = "btrfs";
      options = [ "subvol=@images" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/9927fdda-0636-4e8c-b757-159fa7035812";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-uuid/9927fdda-0636-4e8c-b757-159fa7035812";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6928-CD1C";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
