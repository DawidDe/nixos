{ config, lib, pkgs, ... }:

{
  services.gnome.gnome-keyring = {
    enable = true;
  };

  services.gnome.gcr-ssh-agent = {
    enable = true;
  };
}