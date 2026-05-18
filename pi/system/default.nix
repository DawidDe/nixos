{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./locale.nix
    ./pkgs.nix
    ./user.nix
  ]
}