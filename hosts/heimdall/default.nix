{ config, lib, pkgs, ... }:

{
  mySystem.users = {
    dawid.enable = true;
    omni.enable = true;
    pangolin.enable = true;
    pocket-id.enable = true;
    vault.enable = true;
    ddns.enable = true;
  };
}