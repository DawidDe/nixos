{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    ./configuration.nix
  ];

  # Remove the hardware.raspberrypi block that caused the error

  # SD Image settings
  sdImage = {
    compressImage = false;   # easier to flash
    imageBaseName = "nixos-pi-custom";
  };

  # Bootloader for Raspberry Pi
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Important for Raspberry Pi
  hardware.enableRedistributableFirmware = true;
  # hardware.deviceTree.enable = true;   # usually enabled by the sd-image module

  # Optional but recommended
  boot.kernelParams = [
    "console=ttyAMA0,115200"   # for serial console / early boot logs
  ];

  system.stateVersion = "25.11";
}