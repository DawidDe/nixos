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

  virtualisation.oci-containers.containers.pangolin = {
    image = "docker.io/fosrl/pangolin:latest";
    autoStart = true;
    volumes = [
      "/opt/pangolin/config:/app/config"
    ];
  };

  virtualisation.oci-containers.containers.gerbil = {
    image = "docker.io/fosrl/gerbil:latest";
    autoStart = true;
    dependsOn = [
      "pangolin"
    ];
    cmd = [
      "--reachableAt=http://gerbil:3004"
      "--generateAndSaveKeyTo=/var/config/key"
      "--remoteConfig=http://pangolin:3001/api/v1/"
    ];
    volumes = [
      "/opt/pangolin/config:/var/config"
    ];
    capabilities = {
      NET_ADMIN = true;
      SYS_MODULE = true;
    };
    ports = [
      "80:80"
      "443:443"
      "21820:21820/udp"
      "51820:51820/udp"
    ];
  };

  virtualisation.oci-containers.containers.traefik = {
    image = "docker.io/traefik:latest";
    autoStart = true;
    dependsOn = [
      "pangolin"
    ];
    cmd = [
      "--configFile=/etc/traefik/traefik_config.yml"
    ];
    volumes = [
      "/opt/pangolin/config/traefik:/etc/traefik:ro"
      "/opt/pangolin/config/letsencrypt:/letsencrypt"
      "/opt/pangolin/config/traefik/logs:/var/log/traefik"
    ];
    extraOptions = [
      "--network=container:gerbil"
    ];
  };
}