{ config, lib, pkgs, ... }:

{
  # Enable Podman
  virtualisation.podman.enable = true;
  
  # On aarch64, libkrunfw doesn't support variants, so we disable libkrun entirely
  # This is fine for Raspberry Pi since basic container functionality doesn't need it
  nixpkgs.overlays = [
    (final: prev:
      if prev.stdenv.isAarch64 then
        { libkrun = null; }
      else
        { }
    )
  ];
}
