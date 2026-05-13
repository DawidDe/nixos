{
  description = "Custom NixOS for RPi4";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.pi4 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";  # or use cross
      modules = [ ./pi/sd-image.nix ];
    };
  };
}