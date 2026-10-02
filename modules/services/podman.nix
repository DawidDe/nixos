{ config, lib, pkgs, ...}:

{
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
    extraPackages = with pkgs; {
      aardvark-dns
      netavark
    };
  };
}