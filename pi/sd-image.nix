{ config, lib, pkgs, ... }:

{
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;

  boot.growPartition = true;

  hardware.enableRedistributableFirmware = true;
  hardware.deviceTree.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  # Performance on RPi4
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
}