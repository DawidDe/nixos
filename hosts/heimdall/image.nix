{ config, lib, pkgs, ...}:
{
  imports = [
    ./packages.nix

    # Core modules
    ../../modules/core/locale.nix
    ../../modules/core/users.nix
    ../../modules/core/firewall.nix
    ../../modules/core/ssh.nix
  ];

  networking.hostName = "heimdall";

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";

    age.generateKey = true;
  };

  system.stateVersion = "26.05";

  sdImage.compressImage = false;
}