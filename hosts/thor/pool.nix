{ config, pkgs, ... }:

{
  boot.zfs.devNodes = "/dev/disk/by-id/ata-WDC_WD142KRYZ-01CMKB0_T3G0V1VE";
  boot.zfs.extraPools = [ "hdd" ];

  fileSystems."/mnt/media" = {
    device = "hdd/media";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/mnt/backups" = {
    device = "hdd/backups";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  systemd.services.zfs-load-key = {
    description = "Load ZFS keys";
    wantedBy = [ "zfs-mount.service" ];
    before = [ "zfs-mount.service" ];
    after = [ "zfs-import.target" ];
    path = [ pkgs.zfs ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.zfs}/bin/zfs load-key hdd/backups";
    };
  };

  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
    pools = [ "hdd" ];
  };
}