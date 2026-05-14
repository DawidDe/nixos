{ config, lib, pkgs, ...}:

{
  # Enable Docker
  virtualisation.docker.enable = false;
  virtualisation.docker.enableOnBoot = true;
}