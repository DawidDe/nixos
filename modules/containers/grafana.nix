{
  ...
}:


{
  users.groups.grafana = {
    gid = 2007;
  };

  users.users = {
    grafana = {
      uid = 2007;
      group = "grafana";
      isSystemUser = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /opt/grafana 0750 grafana grafana"
    "d /opt/grafana/data 0750 grafana grafana"
  ];

  virtualisation.oci-containers.containers.grafana = {
    image = "docker.io/grafana/grafana:13.0.14-distroless-slim@sha256:5e007368965b6a4192ee7b82a7df8fe181bfc6339b15a719fbfaa103e42cc997";
    user = "2007:2007";
    volumes = [
      "/opt/grafana/data:/var/lib/grafana"
    ];
    networks = [
      "grafana"
    ];
    autoStart = true;
  };
}