{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S2000G_50026B7382B118EA";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "200G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      home = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S2000G_50026B7382B118EA-part3";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/home";
          mountOptions = [ "defaults" "noatime" ];
        };
      };
    };
  };
}