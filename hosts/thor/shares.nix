{ config, lib, pkgs, ... }:

{
  users.groups.longhorn = {};

  users.users = {
    longhorn = {
      isSystemUser = true;
      group = "longhorn";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      445
    ];
  };

  services.samba.settings = {
    media = {
      path = "/mnt/media";
      browseable = "yes";
      "read only" = "yes";
      "guest ok" = "yes";
    };

    backups = {
      path = "/mnt/backups";
      "read only" = "no";
      "guest ok" = "no";
      "valid users" = "longhorn";
      "hosts allow" = "192.168.178.4 192.168.178.5";
      "hosts deny" = "0.0.0.0/0";
    };
  };

  systemd.services.samba-smbd = {
    after = [ "zfs-mount.service" "zfs.target" ];
    requires = [ "zfs-mount.service" ];
  };
}