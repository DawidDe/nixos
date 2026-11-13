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
      image = "ghcr.io/fosrl/pangolin:ee-1.26.0@sha256:c65b8b4656b3336cea3f2647fc20da955764cd18103c51b2ea6164bbb054e0de";
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
      image = "ghcr.io/fosrl/gerbil:1.6.0@sha256:420f5210b6d1a6d3035f15c3938b5289fee5aeff51ffdcb9b217838338908885";
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
      image = "ghcr.io/traefik/traefik:v3.7.18@sha256:9c437ac4f09ce6f4980a8544902d3475fdf70a1a7c578729581d2535dfa7d635";
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