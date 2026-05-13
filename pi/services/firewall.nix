{ config, lib, pkgs, ...}:

{
  # Enable Firewall
  networking.firewall.enable = true;

  # Rules
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [
    21820
    51820
  ];
}