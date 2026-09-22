{
  description = "landreussi's NixOS + nix-darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Provides the `programs.nvchad` home-manager module, which replaces the
    # hand-maintained copy of the NvChad starter under programs/neovim.
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    nix4nvchad,
    ...
  }: let
    # Every host runs home-manager with the same extra modules available.
    hmModules = [nix4nvchad.homeManagerModules.nvchad];
  in {
    nixosConfigurations.stout = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/stout/configuration.nix
        home-manager.nixosModules.home-manager
        {home-manager.sharedModules = hmModules;}
      ];
    };

    darwinConfigurations.porter = nix-darwin.lib.darwinSystem {
      modules = [
        {nixpkgs.hostPlatform = "aarch64-darwin";}
        ./hosts/porter/configuration.nix
        home-manager.darwinModules.home-manager
        {home-manager.sharedModules = hmModules;}
      ];
    };

    # `nix fmt`
    formatter = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"] (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );
  };
}
