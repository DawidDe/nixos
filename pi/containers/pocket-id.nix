{ config, lib, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
    "d /opt/pocket-id 0755 pocket-id pocket-id"
    "d /opt/pocket-id/data 0755 pocket-id pocket-id"
    "C /run/secrets/pocket-id.env 0600 root root - /persist/secrets/pocket-id.env"
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      pocket-id = {
        image = "ghcr.io/pocket-id/pocket-id:v2";
        user = "1002:1002";
        volumes = [
          "/opt/pocket-id/data:/app/data"
        ];
        environmentFiles = [
          "/run/secrets/pocket-id.env"
        ];
        extraOptions = [
          "--read-only"
          "--cap-drop=ALL"
          "--security-opt=no-new-privileges"
        ];
        autoStart = true;
      };
    };
  };
}