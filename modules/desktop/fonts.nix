{ config, lib, pkgs, ... }:

{
  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    packages = with pkgs; [
      liberation_ttf
    ];
  };
}