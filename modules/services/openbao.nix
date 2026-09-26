{ config, lib, pkgs, ...}:

{
  services.openbao = {
    enable = true;

    settings = {
      ui = true;

      storage.raft = {
        path = "/var/lib/openbao";
      };

      listener.default = {
        type = "tcp";
        address = "127.0.0.1:8200";
      };

      cluster_addr = "http://127.0.0.1:8201";
      api_addr = "https://openbao.dawidde.de";
    };
  };
}