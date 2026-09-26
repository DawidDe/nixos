{ config, lib, pkgs, ...}:

{
  sops.secrets."pocket-id-env" = {
    sopsFile = ../../secrets/pocket-id.env;
    format = "dotenv";
  };
  
  services.pocket-id = {
    enable = true;

    settings = {
      APP_NAME = "Pocket ID";
      APP_URL = "https://pocket-id.domain.de";
      UI_CONFIG_DISABLED=true;
      SESSION_DURATION=60;
      HOME_PAGE_URL="/settings/apps";
      ALLOW_OWN_ACCOUNT_EDIT=false;
      DISABLE_ANIMATIONS=false;
      ACCENT_COLOR="default";
      TRUST_PROXY = true;
      ANALYTICS_DISABLED = true;
      EMAIL_LOGIN_NOTIFICATION_ENABLED=true;
      EMAIL_VERIFICATION_ENABLED=true;
      EMAIL_ONE_TIME_ACCESS_AS_ADMIN_ENABLED=false;
      EMAIL_API_KEY_EXPIRATION_ENABLED=true;
      EMAIL_ONE_TIME_ACCESS_AS_UNAUTHENTICATED_ENABLED=false;
      ALLOW_USER_SIGNUPS="disabled";
      LDAP_ENABLED=false;
    };

    environmentFile = config.sops.secrets.pocket-id-env.path;
  };
}