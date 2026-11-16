{
  ...
}:

{
  mySystem.users = {
    dawid.enable = true;
    media.enable = true;
  };

  networking = {
    useDHCP = false;

    bridges.br0 = {
      interfaces = [ "eno1" ];
    };

    interfaces = {
      eno1.useDHCP = false;
      br0 = {
        useDHCP = true;
        macAddress = "54:9f:35:14:1d:30";
      };
    };
  };
}
