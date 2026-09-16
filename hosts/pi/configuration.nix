{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # Shared system modules
    ../../modules/system/locale.nix
    ../../modules/system/users.nix

    # Shared services modules
    ../../modules/services/firewall.nix
    ../../modules/services/ssh.nix
    ../../modules/services/podman.nix

    # Container modules
    ../../modules/containers/ddns.nix
    ../../modules/containers/omni.nix
    ../../modules/containers/pangolin.nix
    ../../modules/containers/pocket-id.nix
    ../../modules/containers/vault.nix
  ];

  # Host-specific configurations
  networking.hostName = "pi";

  environment.systemPackages = with pkgs; [
    nano
    htop
  ];

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;

    secrets = {
      "ddns-env" = {
        sopsFile = ../../secrets/ddns.env;
        format = "dotenv";
      };
      "pangolin-env" = {
        sopsFile = ../../secrets/pangolin.env;
        format = "dotenv";
      };
      "pocket-id-env" = {
        sopsFile = ../../secrets/pocket-id.env;
        format = "dotenv";
      };
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