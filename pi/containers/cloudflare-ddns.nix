{ config, lib, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
    "C /run/secrets/cloudflare-ddns.env 0600 root root - /persist/secrets/cloudflare-ddns.env"
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      cloudflare-ddns = {
        image = "timothyjmiller/cloudflare-ddns:latest";
        user = "1005:1005";
        environmentFiles = [
          "/run/secrets/cloudflare-ddns.env"
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