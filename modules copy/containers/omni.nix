{ config, lib, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
    "d /opt/omni 0700 omni omni -"
  ];

  virtualisation.oci-containers.containers.omni = {
    image = "ghcr.io/siderolabs/omni:latest";
    extraOptions = [
      "--read-only"
      "--cap-drop=ALL"
      "--security-opt=no-new-privileges:true"
    ];
    capabilities = {
      NET_ADMIN = true;
    };
    volumes = [
      "${config.sops.secrets."omni-key".path}:/omni.asc:ro"
      "${config.sops.secrets."omni-config".path}:/.config.yaml:ro"
      "/opt/omni/sqlite:/_out/sqlite:rw"
      "/opt/omni/etcd:/_out/etcd:rw"
    ];
    cmd = [
      "--config-path=/config.yaml"
    ];
    devices = [
      "/dev/net/tun:/dev/net/tun"
    ];
    networks = [
      "omni"
    ];
    autoStart = true;
  };
}