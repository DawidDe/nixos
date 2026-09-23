{ config, lib, pkgs, ... }:

{
  services.cron = {
    enable = true;

    systemCronJobs = lib.mkIf (config.networking.hostName == "thor") [
      "0 0 * * 1-5 root shutdown -h now"
    ];
  };
}