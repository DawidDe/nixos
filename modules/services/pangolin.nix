{ config, lib, pkgs, ...}:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  networking.firewall.allowedUDPPorts = [
    21820
    51820
  ];

  sops.secrets."pangolin-env" = {
    sopsFile = ../../secrets/pangolin.env;
    format = "dotenv";
  };

  services.pangolin = {
    enable = true;

    baseDomain = "dawidde.de";
    dashboardDomain = "pangolin.dawidde.de";

    letsEncryptEmail = "dawidimb@proton.me";

    environmentFile = config.sops.secrets."pangolin-env".path;
  };
}