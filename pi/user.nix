{ config, lib, pkgs, ... }:

{
  # Dawid
  users.users.dawid = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBKzkzCs5JnFDhBB7YAmnzcd0S6tbMsV1XGJ3B4aod+TdJUI0ngLLyFQxJVpXivExqqHUtPH14HdpV5qWVx5NnV4AAAALdGVybWl1cy5jb20="
    ];
    hashedPassword = "$y$j9T$9P0tRLmzfTI2GfS8u8k2F.$5sG0QnX8V0ukUVUmbrL6/cqPREm2cfRmoy2otFEy7q9";
  };

  users.groups = {
    pangolin.gid = 1001;
    pocket-id.gid = 1002;
    vault.gid = 1003;
    omni.gid = 1004;
    cloudflare-ddns.gid = 1005;
  };

  users.users = {
    pangolin = {
      isNormalUser = true;
      uid = 1001;
      group = "pangolin";
    };

    pocket-id = {
      isNormalUser = true;
      uid = 1002;
      group = "pocket-id";
    };

    vault =  {
      isNormalUser = true;
      uid = 1003;
      group = "vault";
    };

    omni = {
      isNormalUser = true;
      uid = 1004;
      group = "omni";
    };

    cloudflare-ddns = {
      isNormalUser = true;
      uid = 1005;
      group = "cloudflare-ddns";
    };
  };
}