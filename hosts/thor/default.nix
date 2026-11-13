{ config, lib, pkgs, ... }:

{
  mySystem.users = {
    dawid.enable = true;
    media.enable = true;
  };
}