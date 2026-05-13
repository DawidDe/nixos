{
  description = "Raspberry Pi 4 NixOS SD Image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      # Cross-compilation from x86_64 → aarch64 (fastest on GitHub)
      system = "x86_64-linux";
      crossSystem = "aarch64-linux";

      nixosConfig = nixpkgs.lib.nixosSystem {
        inherit system;
        crossSystem = {
          config = "aarch64-unknown-linux-gnu";
        };

        modules = [
          # Official SD image for aarch64
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

          # Your main config
          ./configuration.nix
          ./hardware-configuration.nix
          ./locale.nix
          ./pkgs.nix
          ./user.nix
          ./services/default.nix
          ./containers/default.nix

          # RPi4 specific settings
          ./sd-image.nix
        ];
      };
    in
    {
      nixosConfigurations.rpi4 = nixosConfig;

      # Best output for GitHub runners (cross-compiled)
      packages.${system}.sd-image = nixosConfig.config.system.build.sdImage;

      # Convenience app
      apps.${system}.build-image = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "build-rpi4" ''
          set -euo pipefail
          echo "🚀 Building RPi4 SD image (cross-compilation)..."
          nix build .#sd-image --print-out-paths -L
          echo "✅ Image available in ./result/"
        '');
      };
    };
}