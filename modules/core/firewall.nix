{ config, lib, pkgs, ...}:

{
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    backend = "nftables";
  };
}