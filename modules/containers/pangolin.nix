{ config, lib, pkgs, ...}:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  users.groups.pangolin = {
    gid = 2000;
  };

  users.users = {
    pangolin = {
      uid = 2000;
      group = "pangolin";
      isSystemUser = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /opt/pangolin                     0750 pangolin pangolin"
    "d /opt/pangolin/config              0750 pangolin pangolin"
    "d /opt/pangolin/config/db           0750 pangolin pangolin"
    "d /opt/pangolin/config/letsencrypt  0750 pangolin pangolin"
    "d /opt/pangolin/config/traefik      0750 pangolin pangolin"
    "d /opt/pangolin/config/traefik/logs 0750 pangolin pangolin"
    "d /opt/pangolin/config/traefik/plugins 0750 pangolin pangolin"
  ];

  sops.secrets = {
    pangolin-config = {
      sopsFile = ../../secrets/pangolin-config.yml;
      format = "yaml";
      key = "";
    };
    traefik-dynamic_config = {
      sopsFile = ../../secrets/traefik-dynamic_config.yml;
      format = "yaml";
      key = "";
    };
    traefik-traefik_config = {
      sopsFile = ../../secrets/traefik-traefik_config.yml;
      format = "yaml";
      key = "";
    };
  };

  systemd.services.pangolin-config = {
    description = "Initialize Pangolin configuration";

    wantedBy = [ "multi-user.target" ];
    after = [ "sops-nix.service" ];
    wants = [ "sops-nix.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      if [ ! -e /opt/pangolin/config/config.yml ]; then
        install -o pangolin -g pangolin -m 0640 \
          ${config.sops.secrets.pangolin-config.path} \
          /opt/pangolin/config/config.yml
      fi

      if [ ! -e /opt/pangolin/config/traefik/dynamic_config.yml ]; then
        install -o pangolin -g pangolin -m 0640 \
          ${config.sops.secrets.traefik-dynamic_config.path} \
          /opt/pangolin/config/traefik/dynamic_config.yml
      fi

      if [ ! -e /opt/pangolin/config/traefik/traefik_config.yml ]; then
        install -o pangolin -g pangolin -m 0640 \
          ${config.sops.secrets.traefik-traefik_config.path} \
          /opt/pangolin/config/traefik/traefik_config.yml
      fi
    '';
  };

  virtualisation.oci-containers.containers = {
    pangolin = {
      image = "docker.io/fosrl/pangolin@sha256:f2c0fc54e1b59efcd23b8685e8df84350f363e14ebe1c13ce88a681f181ca49e";
      user = "2000:2000";
      volumes = [
        "/opt/pangolin/config:/app/config"
      ];
      networks = [
        "pangolin"
      ];
      autoStart = true;
    };

    gerbil = {
      image = "docker.io/fosrl/gerbil@sha256:1f6e64eaba7997282c7067ba19922fc7e46b5f73e1a27add3dd66a591d50512f";
      volumes = [
        "/opt/pangolin/config:/var/config"
      ];
      cmd = [
        "--reachableAt=http://gerbil:3004"
        "--generateAndSaveKeyTo=/var/config/key"
        "--remoteConfig=http://pangolin:3001/api/v1/"
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
      networks = [
        "pangolin"
      ];
      dependsOn = [
        "pangolin"
      ];
      autoStart = true;
    };
    
    traefik = {
      image = "ghcr.io/traefik@sha256:c8a121e4bb1347e8fd52657fab12f2cb70b68f8a018895e2068f92c9e519b9c2";
      user = "2000:2000";
      volumes = [
        "/opt/pangolin/config/traefik:/etc/traefik:ro"
        "/opt/pangolin/config/letsencrypt:/letsencrypt"
        "/opt/pangolin/config/traefik/logs:/var/log/traefik"
        "/opt/pangolin/config/traefik/plugins:/plugins-storage"
      ];
      cmd = [
        "--configFile=/etc/traefik/traefik_config.yml"
      ];
      extraOptions = [
        "--network=container:gerbil"
      ];
      dependsOn = [
        "pangolin"
      ];
      autoStart = true;
    };
  };
}