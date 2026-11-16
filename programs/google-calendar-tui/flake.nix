{
  description = "google-calendar-tui, built from upstream's source";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
  in {
    packages = forEachSystem (system: rec {
      google-calendar-tui = nixpkgs.legacyPackages.${system}.callPackage ./package.nix {};
      default = google-calendar-tui;
    });

    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
