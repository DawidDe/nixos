{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./locale.nix
      ./pkgs.nix
      ./user.nix
      ./services/default.nix
      ./containers/default.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pi";

  system.stateVersion = "25.11";
}