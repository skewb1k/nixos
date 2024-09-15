{
  description = "skewbik flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.thinkbook= nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/thinkbook/configuration.nix
        # inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
        ({ pkgs, ... }: {
          environment.systemPackages = [
          ];
        })
      ];
    };
  };
}
