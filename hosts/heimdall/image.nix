{ config, lib, pkgs, ...}:
{
  imports = [
    ./packages.nix

    # Shared system modules
    ../../modules/system/locale.nix
    ../../modules/system/users.nix

    # Shared services modules
    ../../modules/services/firewall.nix
    ../../modules/services/ssh.nix
  ];

  networking.hostName = "heimdall";

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";

    age.generateKey = true;
  };

  system.stateVersion = "26.05";

  sdImage.compressImage = false;
}