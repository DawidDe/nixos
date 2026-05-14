{ config, lib, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
    "d /opt/vault 0755 vault vault"
    "d /opt/vault/data 0755 vault vault"
    "d /opt/vault/logs 0755 vault vault"
  ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      vault = {
        image = "hashicorp/vault:latest";
        user = "1003:1003";
        volumes = [
          "/opt/vault/config.hcl:/vault/config/config.hcl:ro"
          "/opt/vault/data:/vault/data"
          "/opt/vault/logs:/vault/logs"
        ];
        environment = {
          SKIP_CHOWN = "true";
          SKIP_SETCAP = "true";
        };
        extraOptions = [
          "--read-only"
          "--cap-drop=ALL"
          "--cap-add=IPC_LOCK"
          "--ulimit=memlock=-1:-1"
          "--security-opt=no-new-privileges"
        ];
        cmd = [
          "server"
        ];
        autoStart = true;
      };
    };
  };
}