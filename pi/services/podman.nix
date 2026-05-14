{ config, lib, pkgs, ...}:

{
  # Enable Podman
  virtualisation.podman.enable = true;
}