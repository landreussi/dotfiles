{
  lib,
  pkgs,
  inputs ? {},
  ...
}: let
  hasNix4nvchad = inputs ? nix4nvchad;
in {
  imports = lib.optional hasNix4nvchad inputs.nix4nvchad.homeManagerModule;

  config =
    if hasNix4nvchad
    then {
      programs.nvchad = import ../../programs/nvchad.nix {inherit pkgs;};
    }
    else {
      warnings = [
        ''
          nix4nvchad is not wired yet. Pass `inputs.nix4nvchad` through your module args to enable
          the Home Manager module; until then this host keeps using the existing `programs.neovim`
          configuration.
        ''
      ];

      programs.neovim = import ../../programs/neovim.nix {inherit pkgs;};
    };
}
