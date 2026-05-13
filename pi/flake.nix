{
  description = "Custom NixOS SD Image for Raspberry Pi 4";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";   # Change to nixos-unstable if you prefer
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      nixosConfig = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Official SD card image module for aarch64 (RPi)
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

          # All your config files (relative to flake.nix)
          ./configuration.nix
          ./hardware-configuration.nix
          ./locale.nix
          ./pkgs.nix
          ./user.nix
          ./services/default.nix
          ./containers/default.nix

          # Optional extra tweaks for RPi4
          ./sd-image.nix
        ];
      };
    in
    {
      nixosConfigurations.rpi4 = nixosConfig;

      # The SD image you can flash
      packages.${system}.sd-image = nixosConfig.config.system.build.sdImage;

      # Convenience script
      apps.${system}.build-image = {
        type = "app";
        program = toString (pkgs.writeShellScript "build-rpi4-image" ''
          set -euo pipefail
          echo "Building Raspberry Pi 4 NixOS SD image..."
          nix build .#sd-image -L --print-out-paths
          echo "✅ Image ready in ./result/"
        '');
      };
    };
}