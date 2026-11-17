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
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOblVhvH2oeELq13BVQrMrMIpD9mIKirs+1e+TSuAoONAAAABHNzaDo= main"
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
  ];
}
