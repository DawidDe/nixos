{ config, lib, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
    "d /opt/pocket-id 0700 pocket-id pocket-id -"
  ];

  virtualisation.oci-containers.containers.pocket-id = {
    image = "ghcr.io/pocket-id/pocket-id:v2";
    extraOptions = [
      "--read-only"
      "--cap-drop=ALL"
      "--security-opt=no-new-privileges:true"
    ];
    user = "1003:1003";
    volumes = [
      "/opt/pocket-id/data:/app/data"
    ];
    environmentFiles = [
      config.sops.secrets."pocket-id-env".path
    ];
    networks = [
      "pocket-id"
    ];
    autoStart = true;
  };
}