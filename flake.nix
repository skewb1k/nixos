{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      user = "skewbik";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      stateVersion = "24.11";
    in
    {
      nixosConfigurations = {
        thinkbook = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs user stateVersion;
          };
          modules = [
            ./hosts/thinkbook/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs user stateVersion;
          };
          modules = [
	          nixos-wsl.nixosModules.default
            ./hosts/wsl/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
