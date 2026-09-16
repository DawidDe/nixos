{ config, lib, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
    "d /opt/vault 0700 vault vault -"
    ''f+ /opt/vault/config.hcl 0644 root root - ui                 = true\ndisable_clustering = true\ndisable_mlock      = false\n\nstorage "file" {\n  path = "/vault/data"\n}\n\nlistener "tcp" {\n  address     = "0.0.0.0:8200"\n  tls_disable = true\n}''
  ];

  virtualisation.oci-containers.containers.vault = {
    image = "docker.io/hashicorp/vault:latest";
    extraOptions = [
      "--read-only"
      "--cap-drop=ALL"
      "--security-opt=no-new-privileges:true"
    ];
    user = "1004:1004";
    capabilities = {
      IPC_LOCK = true;
    };
    volumes = [
      "/opt/vault/config.hcl:/vault/config/config.hcl:ro"
      "/opt/vault/data:/vault/data"
      "/opt/vault/logs:/vault/logs"
    ];
    environment = {
      SKIP_CHOWN = "true";
      SKIP_SETCAP = "true";
    };
    networks = [
      "vault"
    ];
    cmd = [
      "vault"
    ];
    autoStart = true;
  };
}