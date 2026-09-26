{ config, lib, pkgs, ...}:

{
  networking.firewall.extraInputRules = ''
    iifname { "end0" } ip saddr 192.168.178.1 tcp dport 80 accept
    iifname { "end0" } ip saddr 192.168.178.1 tcp dport 443 accept
    iifname { "end0" } ip saddr 192.168.178.1 udp dport 21820 accept
    iifname { "end0" } ip saddr 192.168.178.1 udp dport 51820 accept
  '';

  sops.secrets."pangolin-env" = {
    sopsFile = ../../secrets/pangolin.env;
    format = "dotenv";
  };

  services.pangolin = {
    enable = true;

    baseDomain = "dawidde.de";
    dashboardDomain = "pangolin.dawidde.de";

    letsEncryptEmail = "dawidimb@proton.me";

    environmentFile = config.sops.secrets."pangolin-env".path;
  };
}