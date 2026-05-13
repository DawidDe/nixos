{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    
    ./configuration.nix
  ];

  # === SD Image specific settings ===
  sdImage = {
    compressImage = false;           # Easier to flash directly
    # imageBaseName = "nixos-pi-custom";  # Optional
  };

  # Bootloader / Raspberry Pi specifics
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Hardware for common Pis (adjust if needed)
  hardware = {
    raspberrypi = {
      # enable or specific config depending on your Pi model
    };
  };

  # Optional: bigger firmware partition if you have lots of DTBs / custom kernel
  # sdImage.firmwareSize = 512;  # in MiB

  system.stateVersion = "25.11";
}