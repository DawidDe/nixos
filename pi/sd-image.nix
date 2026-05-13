# pi/sd-image.nix - Raspberry Pi 4 specific configuration
{ config, lib, pkgs, ... }:

{
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;

  # Essential for SD card usage
  boot.growPartition = true;

  hardware.enableRedistributableFirmware = true;
  hardware.deviceTree.enable = true;

  # Use RPi4 optimized kernel
  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  # Optional but recommended performance tweaks
  boot.tmp.useTmpfs = true;
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
}