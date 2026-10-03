{ config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix

    # Shared system modules
    ../../modules/system/locale.nix
    ../../modules/system/users.nix

    # Shared services modules
    ../../modules/services/firewall.nix
    ../../modules/services/ssh.nix
    ../../modules/services/docker.nix
    ../../modules/services/cloudflare-ddns.nix
    ../../modules/services/openbao.nix
    ../../modules/services/pangolin.nix
    ../../modules/services/newt.nix
    ../../modules/services/pocket-id.nix
    ../../modules/services/omni.nix
  ];

  # Host-specific configurations
  networking.hostName = "heimdall";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = false;
  };

  system.stateVersion = "26.05";
}