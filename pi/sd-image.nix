{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    ./services/ssh.nix
  ];

  nixpkgs.crossSystem = {
    system = "aarch64-linux";
  };
}
