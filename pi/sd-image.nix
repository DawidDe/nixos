{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    ./configuration.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux"
}
