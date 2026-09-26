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
    ../../modules/services/cloudflare-ddns.nix
    ../../modules/services/vault.nix
    ../../modules/services/pangolin.nix
    ../../modules/services/pocket-id.nix

    # Container modules
    ../../modules/containers/omni.nix
  ];

  # Host-specific configurations
  networking.hostName = "heimdall";

  hardware.raspberry-pi.firmware = {
    enable = lib.mkForce false;          # no activation script
    uboot.enable = lib.mkForce false;    # don’t pull the package
  };

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = {
      "omni-config" = {
        sopsFile = ../../secrets/omni.yaml;
        format = "yaml";
        key = "";
      };
      "omni-key" = {
        sopsFile = ../../secrets/omni.asc;
        format = "binary";
        owner = "omni";
        group = "omni";
      };
    };
  };

  system.stateVersion = "26.05";
}