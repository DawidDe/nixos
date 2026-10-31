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
    image = "ghcr.io/fosrl/newt:1.19.1@sha256:c89f01cb387bf6c598959036cbf56306b068a43e8784345bee7398b7af8ee2e1";
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