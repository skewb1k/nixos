{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      thinkbook= nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/zsh/module.nix
          ./modules/hypr/module.nix
          ./modules/waybar/module.nix
          ./hosts/thinkbook/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
