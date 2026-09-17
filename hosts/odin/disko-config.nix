{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S2000G_50026B7382B118EA";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "boot";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              name = "root";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            home = {
              name = "home";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
              };
            };
          };
        };
      };
    };
  };
}