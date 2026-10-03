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

  virtualisation.oci-containers.containers.newt = {
    image = "docker.io/fosrl/newt:1.18.1";
    environment = {
      PANGOLIN_ENDPOINT = "https://pangolin.dawidde.de";
    };
    environmentFiles = [
      config.sops.secrets.newt-env.path
    ];
    autoStart = true;
  };
}