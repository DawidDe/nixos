{ config, lib, pkgs, ...}:
{
  imports = [
    # Shared system modules
    ../../modules/system/locale.nix
    ../../modules/system/users.nix

    # Shared services modules
    ../../modules/services/firewall.nix
    ../../modules/services/ssh.nix
  ];

  networking.hostName = "pi";

  hardware.raspberry-pi.firmware.uboot.enable = true;

  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce [
    "mmc_block"
    "sdhci"
    "sdhci_iproc"
    "bcm2835_dma"
  ];

  environment.systemPackages = with pkgs; [
    nano
    htop
  ];

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";

    age.generateKey = true;
  };

  system.stateVersion = "26.05";
}