{
  description = "Custom NixOS image for Raspberry Pi 4";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";  # Or nixos-unstable
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Base NixOS config for the SD image
      nixosConfig = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Base SD image for aarch64 (includes RPi firmware etc.)
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

          # Your existing modules
          ./configuration.nix
          ./hardware-configuration.nix
          ./locale.nix
          ./pkgs.nix
          ./user.nix
          ./services/default.nix
          ./containers/default.nix
        ];
      };
    in
    {
      # The full NixOS system (useful for other outputs or nixos-rebuild)
      nixosConfigurations.rpi4 = nixosConfig;

      # The SD image (this is what you want to flash)
      packages.${system}.sd-image = nixosConfig.config.system.build.sdImage;

      # Convenience app to build + compress the image
      apps.${system}.build-image = {
        type = "app";
        program = toString (pkgs.writeShellScript "build-rpi-image" ''
          set -euo pipefail
          echo "Building SD image..."
          nix build .#sd-image --print-out-paths
          echo "Image built! Find it in ./result/sd-image/"
        '');
      };
    };
}
