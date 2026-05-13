{
  description = "Pi image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.pi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      modules = [
        ./sd-image.nix
        ({ modulesPath, ... }: {
          nixpkgs.hostPlatform = "aarch64-linux";
        })
      ];
    };

    packages.x86_64-linux.sd-image =
      self.nixosConfigurations.pi.config.system.build.sdImage;
  };
}