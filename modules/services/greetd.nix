{ config, lib, pkgs, ... }:

{
  services.greetd = {
    enable = true;
  };

  programs.regreet = {
    enable = true;
  };
}