# pi/sd-image.nix - Raspberry Pi 4 specific settings
{ config, lib, pkgs, ... }:

{
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;

  # Very useful for SD cards
  boot.growPartition = true;

  hardware.enableRedistributableFirmware = true;

  # Optional but recommended for RPi4
  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  # You can add more here later (zram, etc.)
}