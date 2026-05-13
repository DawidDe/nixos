# sd-image.nix - Extra Raspberry Pi 4 specific tweaks
{ config, lib, pkgs, ... }:

{
  # Optional: extra firmware / boot tweaks if needed
  boot.loader.raspberryPi.enable = lib.mkDefault true;  # Often already handled by sd-image-aarch64
  boot.loader.raspberryPi.version = lib.mkDefault 4;

  # Expand root on first boot (very useful)
  boot.growPartition = true;

  # Optional optimizations for RPi4
  hardware.enableRedistributableFirmware = true;

  # Example: more swap or zram if your config is heavy
  # zramSwap.enable = true;
}
