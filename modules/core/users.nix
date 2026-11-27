{
  config,
  lib,
  ...
}:

let
  cfg = config.mySystem.users;
in
{
  options.mySystem.users = {
    dawid.enable = lib.mkEnableOption "Dawid admin user";
    media.enable = lib.mkEnableOption "Shared media service user";
    omni.enable = lib.mkEnableOption "Shared media service user";
    pangolin.enable = lib.mkEnableOption "Shared media service user";
    pocket-id.enable = lib.mkEnableOption "Shared media service user";
    openbao.enable = lib.mkEnableOption "Shared media service user";
    ddns.enable = lib.mkEnableOption "Shared media service user";
    longhorn.enable = lib.mkEnableOption "Backups share user";
    immich.enable = lib.mkEnableOption "Immich share user";
    prometheus.enable = lib.mkEnableOption "Prometheus user";
    grafana.enable = lib.mkEnableOption "Grafana user";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.dawid.enable {
      users.users = {
        dawid = {
          extraGroups = [
            "wheel"
            "incus-admin"
          ];
          group = "users";
          isNormalUser = true;
          hashedPassword = "$6$lnIb4lO1ZY4t57rV$Kpm69ITMNzKXcPCWpQRaaIg3j.ibVosAxg7N9YdjtFJcD03gg1kSlEtxQUZ08SaWIH.zHczbFOoVzxLLJfvxD0";

          openssh.authorizedKeys.keys = [
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIByqhOs/m3Pxe6I/bqrNA9EbSn3w0TNb+uTV0XZroYHQAAAABHNzaDo= master"
          ];
        };
      };
    })

    (lib.mkIf cfg.media.enable {
      users.groups.media.gid = 20000;
      users.users.media = {
        isSystemUser = true;
        uid = 20000;
        group = "media";
      };
    })

    (lib.mkIf cfg.omni.enable {
      users.groups.omni.gid = 1001;
      users.users.omni = {
        isSystemUser = true;
        uid = 1001;
        group = "omni";
      };
    })

    (lib.mkIf cfg.pangolin.enable {
      users.groups.pangolin.gid = 2000;
      users.users.pangolin = {
        isSystemUser = true;
        uid = 2000;
        group = "pangolin";
      };
    })

    (lib.mkIf cfg.pocket-id.enable {
      users.groups.pocket-id.gid = 2001;
      users.users.pocket-id = {
        isSystemUser = true;
        uid = 2001;
        group = "pocket-id";
      };
    })

    (lib.mkIf cfg.openbao.enable {
      users.groups.openbao.gid = 2002;
      users.users.openbao = {
        isSystemUser = true;
        uid = 2002;
        group = "openbao";
      };
    })

    (lib.mkIf cfg.ddns.enable {
      users.groups.ddns.gid = 2003;
      users.users.ddns = {
        isSystemUser = true;
        uid = 2003;
        group = "ddns";
      };
    })

    (lib.mkIf cfg.longhorn.enable {
      users.groups.longhorn.gid = 2004;
      users.users.longhorn = {
        isSystemUser = true;
        uid = 2004;
        group = "longhorn";
      };
    })

    (lib.mkIf cfg.immich.enable {
      users.groups.immich.gid = 2005;
      users.users.immich = {
        isSystemUser = true;
        uid = 2005;
        group = "immich";
      };
    })

    (lib.mkIf cfg.prometheus.enable {
      users.groups.prometheus.gid = 2006;
      users.users.prometheus = {
        isSystemUser = true;
        uid = 2006;
        group = "prometheus";
      };
    })

    (lib.mkIf cfg.grafana.enable {
      users.groups.grafana.gid = 2006;
      users.users.grafana = {
        isSystemUser = true;
        uid = 2006;
        group = "grafana";
      };
    })
  ];
}
