{ config, lib, pkgs, ...}:

let
  cfg = config.mySystem.users;
in {
  options.mySystem.users = {
    dawid.enable = lib.mkEnableOption "Dawid admin user";
    media.enable = lib.mkEnableOption "Shared media service user";
    omni.enable = lib.mkEnableOption "Shared media service user";
    pangolin.enable = lib.mkEnableOption "Shared media service user";
    pocket-id.enable = lib.mkEnableOption "Shared media service user";
    vault.enable = lib.mkEnableOption "Shared media service user";
    ddns.enable = lib.mkEnableOption "Shared media service user";
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
            "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBKzkzCs5JnFDhBB7YAmnzcd0S6tbMsV1XGJ3B4aod+TdJUI0ngLLyFQxJVpXivExqqHUtPH14HdpV5qWVx5NnV4AAAALdGVybWl1cy5jb20="
          ];
        };
      };
    })

    (lib.mkIf cfg.media.enable {
      users.groups.media.gid = 2000;
      users.users.media = {
        isSystemUser = true;
        uid = 2000;
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
      users.groups.pangolin.gid = 1002;
      users.users.pangolin = {
        isSystemUser = true;
        uid = 1002;
        group = "pangolin";
      };
    })

    (lib.mkIf cfg.pocket-id.enable {
      users.groups.pocket-id.gid = 1003;
      users.users.pocket-id = {
        isSystemUser = true;
        uid = 1003;
        group = "pocket-id";
      };
    })

    (lib.mkIf cfg.vault.enable {
      users.groups.vault.gid = 1004;
      users.users.vault = {
        isSystemUser = true;
        uid = 1004;
        group = "vault";
      };
    })

    (lib.mkIf cfg.ddns.enable {
      users.groups.ddns.gid = 1005;
      users.users.ddns = {
        isSystemUser = true;
        uid = 1005;
        group = "ddns";
      };
    })
  ];
}