{ config, lib, pkgs, ... }:

{
  imports =[
    ./locale.nix
    ./pkgs.nix
    ./user.nix
    ./services/default.nix
    ./containers/default.nix
  ];

  system.stateVersion = "25.11";
}