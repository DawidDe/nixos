{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    ./packages.nix

    # Shared system modules
    ../../modules/system/locale.nix
    ../../modules/system/users.nix

    # Shared services modules
    ../../modules/services/firewall.nix
    ../../modules/services/cups.nix
    ../../modules/services/pipewire.nix
    ../../modules/services/greetd.nix
    ../../modules/services/xdg-portal.nix
    ../../modules/services/polkit.nix
    ../../modules/services/hyprland.nix
    ../../modules/services/keyring.nix
  ];

  # Host-specific configurations
  networking.hostName = "odin";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = "nodev";
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  system.stateVersion = "26.05";
}