{ config, lib, pkgs, ...}:

{
  users.groups.cloudflare-ddns = {
    gid = 2003;
  };

  users.users = {
    cloudflare-ddns = {
      uid = 2003;
      group = "cloudflare-ddns";
      isSystemUser = true;
    };
  };

  sops.secrets."cloudflare-ddns-env" = {
    sopsFile = ../../secrets/cloudflare-ddns.env;
    format = "dotenv";
  };

  virtualisation.oci-containers.containers.cloudflare-ddns = {
    image = "ghcr.io/timothymiller/cloudflare-ddns:2.3.1@sha256:7e43f85f03b94513d2f05d84ac0f39293e9d339e00b2d64b5cc7bf73e8429d94";
    user = "2003:2003";
    environment = {
      CLOUDFLARE_API_TOKEN_FILE = config.sops.secrets.cloudflare-ddns-env.path;
      DOMAINS = "dawidde.de";
    };
    autoStart = true;
  }; 
}