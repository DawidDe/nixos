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
              size = "1G";                    # exactly matches nvme0n1p1
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "8G";                    # exactly matches nvme0n1p2
              content = {
                type = "swap";
              };
            };
            home = {
              size = "1638G";                 # ≈ current nvme0n1p3 (slightly smaller)
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
                # Disko will *not* format it because a filesystem already exists
              };
            };
            root = {
              size = "100%";                  # takes the rest (≈ current nvme0n1p4)
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}