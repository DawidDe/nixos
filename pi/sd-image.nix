{ config, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")

    ./locale.nix
    ./pkgs.nix
    ./user.nix
    ./services/default.nix
    ./containers/default.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "25.11";
}