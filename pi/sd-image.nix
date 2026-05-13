{ config, lib, pkgs, ... }:

{
  imports = [
    ./locale.nix
    ./pkgs.nix
    ./user.nix
    ./services/default.nix
    ./containers/default.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "25.11";
}