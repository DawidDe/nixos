{ config, lib, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
    "d /opt/omni 0755 omni omni"
    "d /opt/omni/sqlite 0755 omni omni"
    "d /opt/omni/etcd 0755 omni omni"
    "C /run/secrets/omni.env 0600 root root - /persist/secrets/omni.env"
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      vault = {
        image = "ghcr.io/siderolabs/omni:latest";
        user = "1003:1003";
        volumes = [
          "/opt/vault/omni.asc:/omni.asc:ro"
          "/opt/omni/sqlite:/_out/sqlite:rw"
          "/opt/omni/etcd:/_out/etcd:rw"
        ];
        environmentFiles = [
          "/run/secrets/omni.env"
        ];
        extraOptions = [
          "--cap-drop=ALL"
          "--cap-add=NET_ADMIN"
          "--security-opt=no-new-privileges"
        ];
        cmd = [
          "--private-key-source=file:///omni.asc"
          "--sqlite-storage-path=/_out/sqlite/omni.db"
          "--event-sink-port=8091"
          "--bind-addr=0.0.0.0:8080"
          "--machine-api-bind-addr=0.0.0.0:8090"
          "--k8s-proxy-bind-addr=0.0.0.0:8100"
          "--advertised-api-url=https://omni.domain.de/"
          "--machine-api-advertised-url=https://api.omni.domain.de"
          "--advertised-kubernetes-proxy-url=https://kube.omni.domain.de"
          "--siderolink-wireguard-advertised-addr=localip:50180"
          "--auth-auth0-enabled=false"
          "--auth-oidc-enabled=true"
          "--auth-oidc-scopes=openid"
          "--auth-oidc-scopes=profile"
          "--auth-oidc-scopes=email"
          "--initial-users=email"
        ];
        autoStart = true;
      };
    };
  };
}