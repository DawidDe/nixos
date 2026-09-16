{ config, lib, pkgs, ...}:

{
  virtualisation.oci-containers.containers.ddns = {
    image = "docker.io/favonia/cloudflare-ddns:latest";
    extraOptions = [
      "--read-only"
      "--cap-drop=ALL"
      "--security-opt=no-new-privileges:true"
    ];
    user = "1005:1005";
    environmentFiles = [
      config.sops.secrets."ddns-env".path
    ];
    autoStart = true;
  };
}