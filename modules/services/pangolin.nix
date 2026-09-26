{ config, lib, pkgs, ...}:

{
  sops."pangolin-env" = {
    sopsFile = ../../secrets/pangolin.env;
    format = "dotenv";
  };

  services.pangolin = {
    enable = true;

    baseDomain = "dawidde.de";
    dashboardDomain = "pangolin.dawidde.de";

    environmentFile = config.sops.secrets."pangolin-env".path;
  };
}