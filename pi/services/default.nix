{ config, lib, pkgs, ...}:

{
  imports = [
    ./networkmanager.nix
    ./firewall.nix
    ./ssh.nix
    ./podman.nix
  ];
}