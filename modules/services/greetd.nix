{ config, lib, pkgs, ... }:

{
  services.greetd = {
    enable = true;
  };

  services.regreet = {
    enable = true;
  };
}