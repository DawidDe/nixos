{ config, lib, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
    "d /opt/pangolin 0700 pangolin pangolin -"
    "d /opt/pangolin/config 0700 pangolin pangolin -"
  ];

  virtualisation.oci-containers.containers.pangolin = {
    image = "docker.io/fosrl/pangolin:ee-1.18.4";
    extraOptions = [
      "--read-only"
      "--cap-drop=ALL"
      "--security-opt=no-new-privileges:true"
    ];
    user = "1002:1002";
    volumes = [
      "/opt/pangolin/config:/app/config"
    ];
    networks = [
      "pangolin"
    ];
    autoStart = true;
  };

  virtualisation.oci-containers.containers.gerbil = {
    image = "docker.io/fosrl/gerbil:1.4.0";
    extraOptions = [
      "--cap-drop=ALL"
      "--security-opt=no-new-privileges:true"
    ];
    capabilities = {
      NET_ADMIN = true;
      SYS_MODULE = true;
    };
    volumes = [
      "/opt/pangolin/config:/var/config"
    ];
    networks = [
      "pangolin"
    ];
    ports = [
      "51820:51820/udp"
      "21280:21280/udp"
      "443:443"
      "80:80"
    ];
    cmd = [
      "--reachableAt=http://gerbil:3004"
      "--generateAndSaveKeyTo=/var/config/key"
      "--remoteConfig=http://pangolin:3001/api/v1/"
    ];
    dependsOn = [
      "pangolin"
    ];
    autoStart = true;
  };

  virtualisation.oci-containers.containers.traefik = {
    image = "docker.io/traefik:v3.6";
    extraOptions = [
      "--read-only"
      "--cap-drop=ALL"
      "--security-opt=no-new-privileges:true"
    ];
    user = "1002:1002";
    volumes = [
      "/opt/pangolin/traefik:/etc/traefik:ro"
      "/opt/pangolin/config/letsencrypt:/letsencrypt:rw"
      "/opt/pangolin/config/traefik/logs:/var/log/traefik:rw"
    ];
    networks = [
      "service:gerbil"
    ];
    cmd = [
      "--configFile=/etc/traefik/traefik_config.yml"
    ];
    dependsOn = [
      "pangolin"
    ];
    autoStart = true;
  };

  virtualisation.oci-containers.containers.newt = {
    image = "docker.io/fosrl/newt";
    environmentFiles = [
      config.sops.secrets."pangolin-env".path
    ];
    networks = [
      "pangolin"
      "pocket-id"
      "vault"
      "omni"
    ];
    autoStart = true;
  };
}