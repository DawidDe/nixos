{ config, lib, pkgs, ... }:

{
  mySystem.users = {
    dawid.enable = true;
    media.enable = true;
  };

  networking = {
    useDHCP = false;

    bridges.br0 = {
      interfaces = [ "eno1" ];
    };

    interfaces = {
      br0.useDHCP = true;
      eno1.useDHCP = false;
    };
  };
}