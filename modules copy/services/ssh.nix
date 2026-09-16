{ config, lib, pkgs, ...}:

{
  services.openssh = {
    enable = true;
    openFirewall = false;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      AllowUsers = [
        "dawid"
      ];

      MaxAuthTries = 3;
    };
  };

  networking.firewall.extraInputRules = ''
    # Allow SSH only from 192.168.178.67
    iifname { "end0", "eno1" } ip saddr 192.168.178.67 tcp dport 22 accept
  '';
}
