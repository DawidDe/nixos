{ config, lib, pkgs, ... }:

{
  services.samba = {
    enable = true;
    
    smbd.enable = true;
    
    settings = {
      mount = {
        path = "/home/dawid/mount";
        "read only" = "no";
        "guest ok" = "yes";
        "force user" = "root";
        "force group" = "root";
      };
    }; 
  };
}