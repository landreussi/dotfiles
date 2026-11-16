{
  description = "atlcli, packaged from upstream's prebuilt release binaries";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    # Every platform upstream publishes a release archive for.
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    inherit (nixpkgs) lib;
    forEachSystem = lib.genAttrs systems;
  in {
    packages = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      atlcli = pkgs.callPackage ./package.nix {};
      update = pkgs.callPackage ./update.nix {};
      default = atlcli;
    });

    apps = forEachSystem (system: {
      # `nix run .#update -- [pins.json] [tag]` re-pins every platform.
      update = {
        type = "app";
        program = lib.getExe self.packages.${system}.update;
      };
    });

    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
