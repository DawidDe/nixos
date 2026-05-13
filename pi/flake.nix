{
  description = "Custom NixOS SD Image for Raspberry Pi 4";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      # Target system
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      nixosConfig = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

          ./configuration.nix
          ./hardware-configuration.nix
          ./locale.nix
          ./pkgs.nix
          ./user.nix
          ./services/default.nix
          ./containers/default.nix
          ./sd-image.nix
        ];
      };
    in
    {
      nixosConfigurations.rpi4 = nixosConfig;

      # Explicitly define for aarch64-linux
      packages.${system}.sd-image = nixosConfig.config.system.build.sdImage;

      # Allow building from x86_64 with emulation
      packages.x86_64-linux.sd-image = nixosConfig.config.system.build.sdImage;

      apps.${system}.build-image = {
        type = "app";
        program = toString (pkgs.writeShellScript "build-rpi4-image" ''
          set -euo pipefail
          echo "Building Raspberry Pi 4 NixOS SD image..."
          nix build .#sd-image -L --print-out-paths
          echo "✅ Done! Image is in ./result/"
        '');
      };
    };
}