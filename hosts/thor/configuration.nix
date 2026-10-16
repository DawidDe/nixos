{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    ./packages.nix

    # Core modules
    ../../modules/core/locale.nix
    ../../modules/core/users.nix
    ../../modules/core/firewall.nix
    ../../modules/core/ssh.nix
    
    # Virtualization modules
    ../../modules/virtualization/incus.nix
    
    # Hardware modules
    ../../modules/hardware/lvm.nix
    
    # Service modules
    ../../modules/services/smb.nix
    ../../modules/services/cron.nix
  ];

  # Host-specific configurations
  networking.hostName = "thor";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  boot.initrd = {
    systemd.enable = true;
    kernelModules = [ "dm_thin_pool" ];
  };

  system.stateVersion = "26.05";
}