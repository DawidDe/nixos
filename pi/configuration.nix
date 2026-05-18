{ config, lib, pkgs, ... }:

{
  imports =[
    ./bootloader.nix
    ./locale.nix
    ./pkgs.nix
    ./user.nix
    ./services/default.nix
    ./containers/default.nix
  ];

  system.stateVersion = "25.11";
}