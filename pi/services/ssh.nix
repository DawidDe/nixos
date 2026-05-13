{ config, lib, pkgs, ... }:

{
  # Enable OpenSSH Service
  services.openssh.enable = true;

  # Configure OpenSSH
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
    AllowUsers = [ "dawid" ];
  };
}