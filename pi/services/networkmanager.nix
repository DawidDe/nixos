{ config, lib, pkgs, ...}:

{
  # Enable NetworkManager
  networking.networkmanager.enable = true;

  networking.hostName = "pi";
}