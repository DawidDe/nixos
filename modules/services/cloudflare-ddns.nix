{ config, lib, pkgs, ...}:

{
  sops.secrets = {
    cloudflare-ddns = {
      sopsFile = ../../secrets/ddns.yaml
    };
  };

  services.cloudflare-ddns = {
    enable = true;
    credentialsFile = config.sops.secrets.cloudflare-ddns.path;

    domains = [
      "dawidde.de"
    ];
    proxied = false;
  };
}