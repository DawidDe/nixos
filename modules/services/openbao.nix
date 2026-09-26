{ config, lib, pkgs, ...}:

{
  services.openbao = {
    enable = true;

    settings = {
      ui = true;

      listener.default = {
        type = "tcp";
      };

      api
    };
  };
}