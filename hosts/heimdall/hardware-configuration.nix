{ config, lib, pkgs, ...}:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-uuid/2178-694E";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  hardware.raspberry-pi.firmware.uboot.enable = true;

  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce [
    "mmc_block"
    "sdhci"
    "sdhci_iproc"
    "bcm2835_dma"
  ];
}