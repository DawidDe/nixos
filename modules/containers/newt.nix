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
    image = "ghcr.io/fosrl/newt:1.20.0@sha256:2170e673c4c72d905764fa22e83d0ae0aa3239fb1ab3b9fcaefb2b00fffb2d6e";
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