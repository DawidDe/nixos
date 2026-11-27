{
  ...
}:


{
  users.groups.prometheus = {
    gid = 2006;
  };

  users.users = {
    prometheus = {
      uid = 2006;
      group = "prometheus";
      isSystemUser = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /opt/prometheus 0750 prometheus prometheus"
    "d /opt/prometheus/data 0750 prometheus prometheus"
  ];

  virtualisation.oci-containers.containers.prometheus = {
    image = "ghcr.io/prometheus/prometheus:v3.16.0@sha256:a85a695dd2368d80b5ce4cbd3ac1e4591b2273fa4fcbe353ac8f24d58254bc1b";
    user = "2006:2006";
    volumes = [
      "/opt/prometheus/data:/prometheus"
    ];
    cmd = [
      "--config.file=/etc/prometheus/prometheus.yml"
      "--storage.tsdb.path=/prometheus"
      "--web.enable-remote-write-receiver"
    ];
    networks = [
      "prometheus"
    ];
    autoStart = true;
  };
}