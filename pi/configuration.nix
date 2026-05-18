{ config, lib, pkgs, ... }:

{
  imports =[
    ./system/default.nix
    ./services/default.nix
    ./containers/default.nix
  ];

  sdImage.compressImage = false;
  system.stateVersion = "25.11";
}