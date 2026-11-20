{ config, lib, pkgs, ...}:

let 
  config = builtins.toJSON {
    ui = true;

    storage.raft = {
      path = "/var/lib/openbao";
    };

    listener.default = {
      type = "tcp";
      address = "0.0.0.0:8200";
      tls_disable = true;
    };

    cluster_addr = "http://openbao:8201";
    api_addr = "https://openbao.dawidde.de";
  };
in 
{
  users.groups.openbao = {
    gid = 2002;
  };

  users.users = {
    openbao = {
      uid = 2002;
      group = "openbao";
      isSystemUser = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /opt/openbao 0750 openbao openbao"
  ];

  systemd.services.config = {
    description = "Generate Openbao config";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };

    script = ''
      install -o openbao -g openbao -m 0640 \
        /dev/stdin /opt/openbao/config.json <<'EOF'
      ${config}
      EOF
    '';
  };

  virtualisation.oci-containers.containers.openbao = {
    image = "ghcr.io/openbao/openbao:2.7.3@sha256:ba4b133eb9586630024e71a617e66f37f29cc3534cdd46a6233e098ceded8dc9";
    user = "2002:2002";
    volumes = [
      "/opt/openbao/config.json:/openbao/config/config.json:ro"
      "/opt/openbao:/var/lib/openbao"
    ];
    cmd = [
      "server"
      "/openbao/config/config.json"
    ];
    networks = [
      "openbao"
    ];
    autoStart = true;
  };
}