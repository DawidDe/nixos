{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    ./configuration.nix
  ];

  sdImage = {
    compressImage = false;  # Easier to flash
    imageBaseName = "nixos-pi4-custom";
  };

  # Bootloader for RPi
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.enableRedistributableFirmware = true;

  boot.kernelParams = [
    "console=ttyAMA0,115200"  # Serial console / early logs
  ];

  # Optional: Enable SSH early or other tweaks
  # services.openssh.enable = true; (already in services probably)

  system.stateVersion = "25.11";
}