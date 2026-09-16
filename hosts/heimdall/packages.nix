{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nano
    htop
  ];
}