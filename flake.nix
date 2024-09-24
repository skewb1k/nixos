{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
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
            inherit inputs outputs user;
            users.users.${user} = {
              isNormalUser = true;
              shell = pkgs.zsh;
              # extraGroups = [
              #   "networkmanager"
              #   "input"
              #   "wheel"
              #   "video"
              #   "audio"
              #   "tss"
              #   "docker"
              # ];
            };
          };
          modules = [
            ./hosts/thinkbook/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
