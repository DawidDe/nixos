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

    # Hardware Modules
    ../../modules/hardware/amdgpu.nix

    # Desktop modules
    ../../modules/desktop/cups.nix
    ../../modules/desktop/pipewire.nix
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/xdg-portal.nix
    ../../modules/desktop/polkit.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/keyring.nix
    ../../modules/desktop/vr.nix
    ../../modules/desktop/pcscd.nix
  ];

  # Host-specific configurations
  networking.hostName = "odin";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  system.stateVersion = "26.05";
}