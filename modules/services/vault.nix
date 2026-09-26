{ config, lib, pkgs, ...}:

{
  services.vault = {
    enable = true;

    storageBackend = "file";
    storagePath = "/vault/data"
  };
}