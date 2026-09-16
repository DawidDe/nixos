{ config, lib, pkgs, ...}:

{
  virtualisation.incus.enable = true;

  networking.firewall = {
    trustedInterfaces = [ "incusbr0" ];
    extraInputRules = ''
      # Allow Incus access only from 192.168.178.67
      iifname "eno1" ip saddr 192.168.178.67 tcp dport 8443 accept
    '';
  };
}