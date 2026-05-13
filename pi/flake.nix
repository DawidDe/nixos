{
  description = "NixOS Pi SD image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages.x86_64-linux.sd-image =
      (nixpkgs.lib.nixosSystem {
        systen = "aarch64-linux";

        modules = [
          ./sd-image.nix

          ({ modulesPath, ... }: {
            nixpkgs.hostPlatform = "aarch64-linux";
          })
        ];
      }).config.system.build.sdImage;
  };
}