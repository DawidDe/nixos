{ config, lib, pkgs, ... }:

{
  services.samba = {
    enable = true;
    
    smbd.enable = true;
  };
}