{
  description = "NixOS Pi SD image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.pi = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./sd-image.nix

        ({ modulesPath, ... }: {
          nixpkgs.hostPlatform = "aarch64-linux";
        })
      ];
    };
  };
}