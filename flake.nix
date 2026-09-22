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

    # Not in nixpkgs; the overlay below exposes these as `pkgs.spotifast` and
    # `pkgs.zapfast` so hosts can list them alongside everything else in
    # `home.packages`.
    spotifast = {
      url = "github:crmne/spotifast";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zapfast = {
      url = "github:crmne/zapfast";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    nix4nvchad,
    spotifast,
    zapfast,
    ...
  }: let
    # Every host runs home-manager with the same extra modules available.
    hmModules = [nix4nvchad.homeManagerModules.nvchad];

    # Flake inputs that only ship packages land in `pkgs` through here, so the
    # host modules never need the inputs themselves.
    overlays = {
      nixpkgs.overlays = [
        (final: prev: {
          spotifast = spotifast.packages.${prev.stdenv.hostPlatform.system}.default;
          zapfast = zapfast.packages.${prev.stdenv.hostPlatform.system}.default;
        })
      ];
    };
  in {
    nixosConfigurations.stout = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/stout/configuration.nix
        home-manager.nixosModules.home-manager
        {home-manager.sharedModules = hmModules;}
        overlays
      ];
    };

    darwinConfigurations.porter = nix-darwin.lib.darwinSystem {
      modules = [
        {nixpkgs.hostPlatform = "aarch64-darwin";}
        ./hosts/porter/configuration.nix
        home-manager.darwinModules.home-manager
        {home-manager.sharedModules = hmModules;}
        overlays
      ];
    };

    # `nix fmt`
    formatter = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"] (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );
  };
}
