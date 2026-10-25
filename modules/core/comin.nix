{ config, lib, pkgs, ... }:

{
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/dawidde/nixos.git";
        branches.main.name = "main";
      }
    ];
  };
}