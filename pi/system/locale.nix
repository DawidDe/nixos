{ config, lib, pkgs, ...}:

{
  # Timezone
  time.timeZone = "Europe/Berlin";

  # Locale
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
    useXkbConfig = false;
  };
}