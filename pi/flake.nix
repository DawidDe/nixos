{
  description = "Pi image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.pi =
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./sd-image.nix
        ];
      };
  };
}