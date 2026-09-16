{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix

    # Shared system modules
    ../../modules/system/locale.nix
    ../../modules/system/users.nix

    # Shared services modules
    ../../modules/services/firewall.nix
    ../../modules/services/ssh.nix
    ../../modules/services/incus.nix
    ../../modules/services/lvm.nix
    ../../modules/services/podman.nix
  ];

  # Host-specific configurations
  networking.hostName = "heimdall";

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

  environment.systemPackages = with pkgs; [
    nano
    htop
    zfs
  ];

  system.stateVersion = "26.05";
}