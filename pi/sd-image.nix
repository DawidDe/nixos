{ config, lib, pkgs, ... }:

{
  imports = [
    "${pkgs.path}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

    ./locale.nix
    ./pkgs.nix
    ./user.nix
    ./services/default.nix
    ./containers/default.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "25.11";
}