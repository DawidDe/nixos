{ config, lib, pkgs, ...}:

{
  networking.firewall.allowedUDPPorts = [
    21820
    51820
  ];

  sops.secrets."newt-env" = {
    sopsFile = ../../secrets/newt.env;
    format = "dotenv";
  };

  services.newt = {
    enable = true;

    settings = {
      endpoint = "https://pangolin.dawidde.de";
    };

    environmentFile = config.sops.secrets.newt-env.path;
  };
}