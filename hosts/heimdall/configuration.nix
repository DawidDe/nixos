{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix

    # Shared system modules
    ../../modules/system/locale.nix
    ../../modules/system/users.nix

    # Shared services modules
    ../../modules/services/firewall.nix
    ../../modules/services/ssh.nix
    ../../modules/services/podman.nix
    #../../modules/services/cloudflare-ddns.nix
    #../../modules/services/vault.nix
    #../../modules/services/pangolin.nix
    #../../modules/services/pocket-id.nix
  ];

  # Host-specific configurations
  networking.hostName = "heimdall";

  hardware.raspberry-pi.firmware = {
    enable = lib.mkForce false;
    uboot.enable = lib.mkForce false;
  };
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  boot.kernel.sysctl."vm.mmap_rnd_bits" = lib.mkForce 18;

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;
  };

  system.stateVersion = "26.05";
}