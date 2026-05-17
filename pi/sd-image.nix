{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    ./locale.nix
    ./pkgs.nix
    ./user.nix
    ./services/ssh.nix
  ];

  system.stateVersion = "25.11";

  nixpkgs.crossSystem = {
    system = "aarch64-linux";
  };
}
