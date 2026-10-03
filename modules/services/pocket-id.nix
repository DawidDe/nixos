{ config, lib, pkgs, ...}:

{
  users.groups.pocket-id = {
    gid = 2001;
  };

  users.users = {
    pocket-id = {
      uid = 2001;
      group = "pocket-id";
      isSystemUser = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /opt/pocket-id 0750 pocket-id pocket-id"
  ];

  sops.secrets."pocket-id-env" = {
    sopsFile = ../../secrets/pocket-id.env;
    format = "dotenv";

    owner = "pocket-id";
    group = "pocket-id";
  };

  virtualisation.oci-containers.containers.pocket-id = {
    image = "ghcr.io/pocket-id/pocket-id:v2";
    user = "2001:2001";
    volumes = [
      "/opt/pocket-id:/app/data"
    ];
    environment = {
      # General
      APP_NAME = "Pocket ID";
      APP_URL = "https://pocket-id.dawidde.de";
      HOME_PAGE_URL = "/settings/apps";

      # Auth & Sessions
      SESSION_DURATION = "60";
      EMAIL_VERIFICATION_ENABLED = "true";
      EMAIL_LOGIN_NOTIFICATION_ENABLED = "true";
      EMAIL_API_KEY_EXPIRATION_ENABLED = "true";
      EMAIL_ONE_TIME_ACCESS_AS_ADMIN_ENABLED = "false";
      EMAIL_ONE_TIME_ACCESS_AS_UNAUTHENTICATED_ENABLED = "false";

      # User Management
      ALLOW_OWN_ACCOUNT_EDIT = "false";
      ALLOW_USER_SIGNUPS = "disabled";
      LDAP_ENABLED = "false";

      # UI
      ACCENT_COLOR = "default";
      DISABLE_ANIMATIONS = "false";
      UI_CONFIG_DISABLED = "true";

      # Privacy & Analytics
      ANALYTICS_DISABLED = "true";

      # Reverse Proxy
      TRUST_PROXY = "true";
    };
    environmentFiles = [
      config.sops.secrets.pocket-id-env.path
    ];
    networks = [
      "pocket-id"
    ];
    autoStart = true;
  };
}