{
  description = "NixOS configuration for my Raspberry Pi 4";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.pi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ./configuration.nix
      ];
    };

    images.pi = self.nixosConfigurations.pi.config.system.build.sdImage;
  };
}