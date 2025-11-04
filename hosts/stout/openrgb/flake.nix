{
  description = "OpenRGB HardwareSync Plugin overlay";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    openrgb = pkgs.openrgb-with-all-plugins.overrideAttrs (old: {
      src = pkgs.fetchFromGitLab {
        owner = "CalcProgrammer1";
        repo = "OpenRGB";
        rev = "master";
        sha256 = "sha256-xaw+96tCnw5E6cGP0cUsYSKfHBlkNxEzJXT8eL7CjCE=";
      };
      patches = [];
      postPatch = ''
        patchShebangs scripts/build-udev-rules.sh
        substituteInPlace scripts/build-udev-rules.sh \
          --replace-fail "/bin/env chmod" "${pkgs.coreutils}/bin/chmod"
      '';
    }); # Inline overlay
    overlay = final: prev: {
      openrgb-plugin-hardwaresync = prev.openrgb-plugin-hardwaresync.overrideAttrs (old: {
        src = prev.fetchFromGitLab {
          owner = "OpenRGBDevelopers";
          repo = "OpenRGBHardwareSyncPlugin";
          rev = "master";
          sha256 = "00aykbmp605z7fqn5q7f6n3fvn1wzr6i0g3nnz3yr4kx0v69ygq1";
        };

        patches = [];
        postPatch = ''
          # Use the source of openrgb from nixpkgs instead of the submodule
          rmdir OpenRGB
          ln -s ${openrgb.src} OpenRGB
          # Remove prebuilt stuff
          rm -r dependencies/lhwm-cpp-wrapper
          echo "include(OpenRGB/OpenRGB.pro)" > OpenRGBHardwareSyncPlugin.pro
        '';

        buildInputs =
          old.buildInputs
          ++ [
            pkgs.hidapi
            pkgs.nlohmann_json
            pkgs.libusb1
          ];
      });
    };

    pkgsWithOverlay = import nixpkgs {
      inherit system;
      overlays = [overlay];
    };
  in {
    packages.${system} = {
      # Default package
      default = pkgsWithOverlay.openrgb-plugin-hardwaresync;

      # Named package
      openrgb-plugin-hardwaresync = pkgsWithOverlay.openrgb-plugin-hardwaresync;
    };
  };
}
