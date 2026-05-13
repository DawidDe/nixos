{
  description = "Raspberry Pi 4 NixOS SD Image - Cross Compiled";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      # Build machine (GitHub runner)
      buildSystem = "x86_64-linux";
    in
    {
      nixosConfigurations.rpi4 = nixpkgs.lib.nixosSystem {
        system = buildSystem;   # Important: this is the build platform

        modules = [
          # SD Image base
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

          # Your configuration files
          ./configuration.nix
          ./hardware-configuration.nix
          ./locale.nix
          ./pkgs.nix
          ./user.nix
          ./services/default.nix
          ./containers/default.nix

          # RPi4 specific
          ./sd-image.nix

          # === Cross-compilation settings ===
          {
            nixpkgs.crossSystem = {
              config = "aarch64-unknown-linux-gnu";
            };

            # Help with some packages that are picky about cross
            nixpkgs.config.allowUnsupportedSystem = true;
          }
        ];
      };

      # Main output - build this
      packages.${buildSystem}.sd-image =
        self.nixosConfigurations.rpi4.config.system.build.sdImage;

      # Convenience
      apps.${buildSystem}.build-image = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${buildSystem}.writeShellScript "build-rpi4" ''
          set -euo pipefail
          echo "🚀 Building RPi 4 SD image via cross-compilation..."
          nix build .#sd-image -L --print-out-paths
          echo "✅ Success! Image is in ./result/sd-image/"
        '');
      };
    };
}