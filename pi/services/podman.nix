{ config, lib, pkgs, ...}:

{
  # Enable Podman
  virtualisation.podman.enable = false;
}