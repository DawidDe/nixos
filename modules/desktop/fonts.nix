{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    liberation_ttf
  ];
}