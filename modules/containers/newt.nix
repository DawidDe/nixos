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
    image = "ghcr.io/fosrl/newt@sha256:0189c8287058b800cca825590e4c39946b3815344ca48678dd0b96616d639319";
    environment = {
      PANGOLIN_ENDPOINT = "https://pangolin.dawidde.de";
    };
    environmentFiles = [
      config.sops.secrets.newt-env.path
    ];
    networks = [
      "pangolin"
      "pocket-id"
      "openbao"
      "omni"
    ];
    autoStart = true;
  };
}