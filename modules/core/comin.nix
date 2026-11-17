{
  ...
}:

{
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://gitlab.com/dawidde/nixos.git";
        branches.main.name = "main";
      }
    ];
  };
}
