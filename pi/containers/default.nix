{ config, lib, pkgs, ...}:

{
  imports = [
    ./pocket-id.nix
    ./vault.nix
    ./omni.nix
    ./cloudflare-ddns.nix
  ];
}