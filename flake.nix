{
  description = "A flake describing my Nixos systems.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    basalt.url = "github:MegalithOfficial/basalt-launcher";
  };

  outputs = { self, nixpkgs, disko, nixos-hardware, sops-nix, ...}@inputs: {
    nixosConfigurations = {
      odin = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          basalt = basalt;
          };

        modules = [
          disko.nixosModules.disko
          ./hosts/odin/configuration.nix
        ];
      };

      thor = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          disko.nixosModules.disko
          ./hosts/thor/configuration.nix
        ];
      };

      heimdall-image = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          nixos-hardware.nixosModules.raspberry-pi-4
          sops-nix.nixosModules.sops
          ./hosts/heimdall/image.nix
        ];
      };

      heimdall = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          sops-nix.nixosModules.sops
          ./hosts/heimdall/configuration.nix
        ];
      };
    };
  };
}
