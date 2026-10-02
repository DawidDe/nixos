{ config, lib, pkgs, ...}:

let
  baseDomain = "dawidde.de";
in
{
  systemd.tmpfiles.rules = [
    "d /opt/pangolin                 0755 root root -"
    "d /opt/pangolin/config          0755 root root -"
    "d /opt/pangolin/config/db       0755 root root -"
    "d /opt/pangolin/config/letsencrypt 0755 root root -"
    "d /opt/pangolin/config/traefik  0755 root root -"
    "d /opt/pangolin/config/traefik/logs 0755 root root -"
  ];

  sops.secrets."pangolin/server-secret" = {
    sopsFile = ../../secrets/pangolin.yaml;
  };

  systemd.services.pangolin-config-init = {
    description = "Write Pangolin config.yml once";
    wantedBy = [ "multi-user.target" ];
    after = [ "sops-nix.service" ];
    before = [ "podman-pangolin.service" ];

    unitConfig.ConditionPathExists = "!/opt/pangolin/config/config.yml";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "write-pangolin-config" ''
        set -euo pipefail

        install -d -m 0755 \
          /opt/pangolin/config \
          /opt/pangolin/config/db \
          /opt/pangolin/config/letsencrypt \
          /opt/pangolin/config/traefik \
          /opt/pangolin/config/traefik/logs

        cat > /opt/pangolin/config/traefik/traefik_config.yml <<EOF
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
              email: "dawidimb@proton.me"
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
        EOF

        cat > /opt/pangolin/config/traefik/dynamic_config.yml <<EOF
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
              rule: "Host(\`pangolin.${baseDomain}\`)"
              service: next-service
              entryPoints:
                - web
              middlewares:
                - redirect-to-https
                - badger

            next-router:
              rule: "Host(\`pangolin.${baseDomain}\`) && !PathPrefix(\`/api/v1\`)"
              service: next-service
              entryPoints:
                - websecure
              middlewares:
                - badger
              tls:
                certResolver: letsencrypt

            api-router:
              rule: "Host(\`pangolin.${baseDomain}\`) && PathPrefix(\`/api/v1\`)"
              service: api-service
              entryPoints:
                - websecure
              middlewares:
                - badger
              tls:
                certResolver: letsencrypt

            ws-router:
              rule: "Host(\`pangolin.${baseDomain}\`)"
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
        EOF

        cat > /opt/pangolin/config/config.yml <<EOF
        gerbil:
          start_port: 51820
          base_endpoint: "pangolin.${baseDomain}"

        app:
          dashboard_url: "https://pangolin.${baseDomain}"
          log_level: "info"
          telemetry:
            anonymous_usage: true

        domains:
          domain1:
            base_domain: "${baseDomain}"

        server:
          secret: "$(cat ${config.sops.secrets."pangolin/server-secret".path})"
          cors:
            origins: ["https://pangolin.${baseDomain}"]
            methods: ["GET", "POST", "PUT", "DELETE", "PATCH"]
            allowed_headers: ["X-CSRF-Token", "Content-Type"]
            credentials: false

        flags:
          require_email_verification: false
          disable_signup_without_invite: true
          disable_user_create_org: false
          allow_raw_resources: true

        email:
          smtp_host: "smtp.example.com"
          smtp_port: 587
          smtp_user: "smtp-user"
          smtp_pass: "smtp-password"
          no_reply: "noreply@example.com"
        EOF

        chmod 0400 /opt/pangolin/config/config.yml
        chmod 0644 /opt/pangolin/config/traefik/traefik_config.yml
        chmod 0644 /opt/pangolin/config/traefik/dynamic_config.yml

        if [ ! -f /opt/pangolin/config/letsencrypt/acme.json ]; then
          printf '{}\n' > /opt/pangolin/config/letsencrypt/acme.json
        fi

        chmod 0600 /opt/pangolin/config/letsencrypt/acme.json
      '';
    };
  };

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