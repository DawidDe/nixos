{ config, lib, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
      "d /opt/pangolin                     0755 pangolin pangolin"
      "d /opt/pangolin/config              0755 pangolin pangolin"
      "d /opt/pangolin/config/traefik      0755 pangolin pangolin"
      "d /opt/pangolin/config/traefik/logs 0755 pangolin pangolin"
      "d /opt/pangolin/config/letsencrypt  0755 pangolin pangolin"
      "C /run/secrets/newt.env 0600 root root - /persist/secrets/newt.env"
    ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      pangolin = {
        image = "fosrl/pangolin:ee-latest";
        user = "1001:1001";
        volumes = [
          "/opt/pangolin/config:/app/config"
        ];
        extraOptions = [
          "--read-only"
          "--cap-drop=ALL"
          "--security-opt=no-new-privileges"
          "--network=pangolin"
        ];
        autoStart = true;
      };

      gerbil = {
        image = "docker.io/fosrl/gerbil:1.4.0";
        volumes = [
          "/opt/pangolin/config:/var/config"
        ];
        ports = [
          "80:80"
          "443:443"
          "21820:21820/udp"
          "51820:51820/udp"
        ];
        extraOptions = [
          "--cap-drop=ALL"
          "--cap-add=NET_ADMIN"
          "--cap-add=SYS_MODULE"
          "--security-opt=no-new-privileges"
          "--network=pangolin"
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

      traefik = {
        image = "docker.io/traefik:v3.6";
        user = "1001:1001";
        volumes = [
          "/opt/pangolin/config/traefik:/etc/traefik:ro"
          "/opt/pangolin/config/letsencrypt:/letsencrypt"
          "/opt/pangolin/config/traefik/logs:/var/log/traefik"
          "/opt/pangolin/config/traefik/plugins-storage:/plugins-storage"
        ];
        extraOptions = [
          "--read-only"
          "--cap-drop=ALL"
          "--security-opt=no-new-privileges"
          "--network=container:gerbil"
        ];
        cmd = [
          "--configFile=/etc/traefik/traefik_config.yml"
        ];
        dependsOn = [
          "pangolin"
        ];
        autoStart = true;
      };

      newt = {
        image = "fosrl/newt";
        user = "1001:1001";
        environmentFiles = [
          "/run/secrets/newt.env"
        ];
        autoStart = true;
      };
    };
  };

  systemd.services.docker-networks = {
  description = "Create docker networks";
  after = [ "docker.service" ];
  requires = [ "docker.service" ];
  wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
  };

  script = ''
    ${pkgs.docker}/bin/docker network inspect pangolin >/dev/null 2>&1 || \
    ${pkgs.docker}/bin/docker network create \
      --driver bridge \
      pangolin
  '';
  };
}