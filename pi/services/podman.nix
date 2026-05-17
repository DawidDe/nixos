{ config, lib, pkgs, ...}:

{
  # Enable Podman
  virtualisation.podman.enable = true;

  virtualisation.podman.package = if stdenv.targetPlatform.isAarch64 then
    pkgs.podman.override { libkrun = null; }
  else
    pkgs.podman;
}
