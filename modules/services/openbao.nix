{ config, lib, pkgs, ...}:

{
  users = {
    users.openbao = {
      isSystemUser = true;
      group = "openbao";
      uid = 1100;
    };
    
    groups.openbao = {
      gid = 1100;
    };
  };

  systemd.tmpfiles.rules = [
    "d /opt/openbao 0700 openbao openbao"
  ];

  services.openbao = {
    enable = true;

    settings = {
      ui = true;

      storage.raft = {
        path = "/opt/openbao"
      };

      listener.default = {
        type = "tcp";
        address = "127.0.0.1:8200"
      };
    };
  };
}