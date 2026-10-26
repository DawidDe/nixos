{ config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix

    # Core modules
    ../../modules/core/locale.nix
    ../../modules/core/users.nix 
    ../../modules/core/firewall.nix
    ../../modules/core/ssh.nix
    ../../modules/core/comin.nix
    
    # Virtualization modules
    ../../modules/virtualization/docker.nix
    
    # Container modules
    ../../modules/containers/cloudflare-ddns.nix
    ../../modules/containers/openbao.nix
    ../../modules/containers/pangolin.nix
    ../../modules/containers/newt.nix
    ../../modules/containers/pocket-id.nix
    ../../modules/containers/omni.nix
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