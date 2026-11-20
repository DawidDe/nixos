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
    image = "ghcr.io/fosrl/newt:1.20.1@sha256:03561e3f3d10b94ee7839318ae46e5acf8b4431550ea1d0e15666ab60caa2e43";
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
      "supertokens_supertokens"
    ];
    autoStart = true;
  };
}
