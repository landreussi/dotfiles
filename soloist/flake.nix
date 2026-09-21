{
  description = "Spotify Soloist, packaged from Spotify's official prebuilt Linux archives";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    # Upstream publishes x86_64, arm64 and arm32 Linux builds and nothing else,
    # so there is deliberately no darwin system here.
    systems = ["x86_64-linux" "aarch64-linux" "armv7l-linux"];
    inherit (nixpkgs) lib;
    forEachSystem = lib.genAttrs systems;
  in {
    overlays.default = final: _prev: {
      soloist = final.callPackage ./package.nix {};
    };

    packages = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      soloist = pkgs.callPackage ./package.nix {};
      update = pkgs.callPackage ./update.nix {};
      default = soloist;
    });

    apps = forEachSystem (system: let
      packages = self.packages.${system};
    in rec {
      # `nix run .#update -- path/to/pins.json` re-pins every architecture.
      update = {
        type = "app";
        program = lib.getExe packages.update;
      };
      soloist = {
        type = "app";
        program = lib.getExe packages.soloist;
      };
      default = soloist;
    });

    # The modules resolve the package through their own directory, so consumers
    # can import them without also applying the overlay.
    nixosModules = rec {
      soloist = ./nixos-module.nix;
      default = soloist;
    };

    homeModules = rec {
      soloist = ./home-module.nix;
      default = soloist;
    };
    # home-manager's older attribute name, kept for consumers still using it.
    homeManagerModules = self.homeModules;

    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
