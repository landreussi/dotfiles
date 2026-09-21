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

    # Spotify's headless Connect player. Kept as its own flake under ./soloist
    # so other machines can consume it without this repo; it is not in nixpkgs,
    # since upstream ships prebuilt Linux binaries and no source.
    soloist = {
      url = "path:./soloist";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    nix4nvchad,
    soloist,
    ...
  }: let
    # Every host runs home-manager with the same extra modules available.
    hmModules = [nix4nvchad.homeManagerModules.nvchad];
    # soloist has no darwin build, so only the Linux hosts get its module.
    linuxHmModules = hmModules ++ [soloist.homeModules.default];
  in {
    nixosConfigurations.stout = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/stout/configuration.nix
        {nixpkgs.overlays = [soloist.overlays.default];}
        home-manager.nixosModules.home-manager
        {home-manager.sharedModules = linuxHmModules;}
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

    # `nix run .#update-soloist` re-pins ./soloist/pins.json against Spotify's
    # CDN. Its builds expire 90 days after they are made, so this has to be run
    # periodically even when nothing else changes.
    apps.x86_64-linux.update-soloist = soloist.apps.x86_64-linux.update;

    # `nix fmt`
    formatter = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"] (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );
  };
}
