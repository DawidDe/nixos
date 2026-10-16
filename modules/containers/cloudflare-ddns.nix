{ config, lib, pkgs, ...}:

{
  sops.secrets."cloudflare-ddns-env" = {
    sopsFile = ../../secrets/cloudflare-ddns.env;
    format = "dotenv";
  };

  services.cloudflare-ddns = {
    enable = true;
    credentialsFile = config.sops.secrets.cloudflare-ddns-env.path;

    domains = [
      "dawidde.de"
    ];
    proxied = "false";
  };
}