{ config, lib, pkgs, ... }:

let
  dashboardDomain = "pangolin.dawidde.de";
  baseDomain      = "dawidde.de";
  acmeEmail       = "dawidimb@proton.me";

  serverSecretFile = sops.secrets."pangolin/server-secret".path;

  dir    = "/opt/pangolin/config";
  podman = "${config.virtualisation.podman.package}/bin/podman";

  configYml = pkgs.writeText "pangolin-config.yml" ''
    gerbil:
        start_port: 51820
        base_endpoint: "${dashboardDomain}"

    app:
        dashboard_url: "https://${dashboardDomain}"
        log_level: "info"
        telemetry:
            anonymous_usage: true

    domains:
        domain1:
            base_domain: "${baseDomain}"

    server:
        secret: "@SERVER_SECRET@"
        cors:
            origins: ["https://${dashboardDomain}"]
            methods: ["GET", "POST", "PUT", "DELETE", "PATCH"]
            allowed_headers: ["X-CSRF-Token", "Content-Type"]
            credentials: false

    flags:
        require_email_verification: false
        disable_signup_without_invite: true
        disable_user_create_org: false
        allow_raw_resources: true
  '';

  traefikConfig = pkgs.writeText "traefik_config.yml" ''
    api:
      insecure: true
      dashboard: true

    providers:
      http:
        endpoint: "http://pangolin:3001/api/v1/traefik-config"
        pollInterval: "5s"
      file:
        filename: "/etc/traefik/dynamic_config.yml"

    experimental:
      plugins:
        badger:
          moduleName: "github.com/fosrl/badger"
          version: "v1.4.0"

    log:
      level: "INFO"
      format: "common"
      maxSize: 100
      maxBackups: 3
      maxAge: 3
      compress: true

    certificatesResolvers:
      letsencrypt:
        acme:
          httpChallenge:
            entryPoint: web
          email: "${acmeEmail}"
          storage: "/letsencrypt/acme.json"
          caServer: "https://acme-v02.api.letsencrypt.org/directory"

    entryPoints:
      web:
        address: ":80"
      websecure:
        address: ":443"
        transport:
          respondingTimeouts:
            readTimeout: "30m"
        http:
          tls:
            certResolver: "letsencrypt"
          encodedCharacters:
            allowEncodedSlash: true
            allowEncodedQuestionMark: true

    serversTransport:
      insecureSkipVerify: true

    ping:
      entryPoint: "web"
  '';

  traefikDynamic = pkgs.writeText "dynamic_config.yml" ''
    http:
      middlewares:
        badger:
          plugin:
            badger:
              disableForwardAuth: true
        redirect-to-https:
          redirectScheme:
            scheme: https

      routers:
        main-app-router-redirect:
          rule: "Host(`${dashboardDomain}`)"
          service: next-service
          entryPoints:
            - web
          middlewares:
            - redirect-to-https
            - badger

        next-router:
          rule: "Host(`${dashboardDomain}`) && !PathPrefix(`/api/v1`)"
          service: next-service
          entryPoints:
            - websecure
          middlewares:
            - badger
          tls:
            certResolver: letsencrypt

        api-router:
          rule: "Host(`${dashboardDomain}`) && PathPrefix(`/api/v1`)"
          service: api-service
          entryPoints:
            - websecure
          middlewares:
            - badger
          tls:
            certResolver: letsencrypt

        ws-router:
          rule: "Host(`${dashboardDomain}`)"
          service: api-service
          entryPoints:
            - websecure
          middlewares:
            - badger
          tls:
            certResolver: letsencrypt

      services:
        next-service:
          loadBalancer:
            servers:
              - url: "http://pangolin:3002"

        api-service:
          loadBalancer:
            servers:
              - url: "http://pangolin:3000"

    tcp:
      serversTransports:
        pp-transport-v1:
          proxyProtocol:
            version: 1
        pp-transport-v2:
          proxyProtocol:
            version: 2
  '';

  waitForPangolin = pkgs.writeShellScript "wait-for-pangolin" ''
    for _ in $(seq 1 90); do
      if ${podman} exec pangolin curl -fsS http://localhost:3001/api/v1/ >/dev/null 2>&1; then
        exit 0
      fi
      sleep 2
    done
    echo "pangolin did not become healthy in time" >&2
    exit 1
  '';
in
{
  sops.secrets."pangolin-server-secret" = { };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 21820 51820 ];

  boot.kernelModules = [ "wireguard" ];

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      pangolin = {
        image = "docker.io/fosrl/pangolin:latest";
        networks = [ "pangolin" ];
        volumes = [ "${dir}:/app/config" ];
      };

      gerbil = {
        image = "docker.io/fosrl/gerbil:latest";
        networks = [ "pangolin" ];
        dependsOn = [ "pangolin" ];
        cmd = [
          "--reachableAt=http://gerbil:3004"
          "--generateAndSaveKeyTo=/var/config/key"
          "--remoteConfig=http://pangolin:3001/api/v1/"
        ];
        volumes = [ "${dir}:/var/config" ];
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

      traefik = {
        image = "docker.io/traefik:v3.7";
        dependsOn = [ "pangolin" "gerbil" ];
        cmd = [ "--configFile=/etc/traefik/traefik_config.yml" ];
        volumes = [
          "${dir}/traefik:/etc/traefik:ro"
          "${dir}/letsencrypt:/letsencrypt"
          "${dir}/traefik/logs:/var/log/traefik"
        ];
        extraOptions = [ "--network=container:gerbil" ];
      };
    };
  };

  systemd.services = {
    pangolin-setup = {
      description = "Prepare Pangolin directories, network and config files";
      before = [ "podman-pangolin.service" "podman-gerbil.service" "podman-traefik.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        set -euo pipefail

        ${podman} network exists pangolin || ${podman} network create pangolin

        install -d -m 0755 ${dir} ${dir}/db ${dir}/letsencrypt ${dir}/traefik ${dir}/traefik/logs

        install -m 0644 ${traefikConfig}  ${dir}/traefik/traefik_config.yml
        install -m 0644 ${traefikDynamic} ${dir}/traefik/dynamic_config.yml

        secret="$(< ${serverSecretFile})"
        if [ -z "$secret" ]; then
          echo "pangolin server secret is empty" >&2
          exit 1
        fi
        shopt -u patsub_replacement 2>/dev/null || true
        content="$(< ${configYml})"
        ( umask 077; printf '%s\n' "''${content//@SERVER_SECRET@/$secret}" > ${dir}/config.yml.tmp )
        mv ${dir}/config.yml.tmp ${dir}/config.yml
      '';
    };

    podman-pangolin = {
      requires = [ "pangolin-setup.service" ];
      after = [ "pangolin-setup.service" ];
      serviceConfig = {
        TimeoutStartSec = "10min";
        ExecStartPost = [ "${waitForPangolin}" ];
      };
    };

    podman-gerbil = {
      requires = [ "pangolin-setup.service" ];
      after = [ "pangolin-setup.service" ];
      serviceConfig.TimeoutStartSec = "10min";
    };

    podman-traefik = {
      requires = [ "pangolin-setup.service" ];
      after = [ "pangolin-setup.service" ];
      serviceConfig.TimeoutStartSec = "10min";
    };
  };
}