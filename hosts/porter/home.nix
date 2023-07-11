super@{ config, pkgs, homebrew, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  users.users.landreussi = {
    name = "landreussi";
    home = "/Users/landreussi";
  };

  home-manager.users.landreussi = {
    home = {
      username = "landreussi";
      homeDirectory = "/Users/landreussi";
      packages = with pkgs; [
        fd
        fzf
        gh
        go
        htop
        jq
        lazygit
        nixfmt
        neofetch
        pass
        ripgrep
        spotify-tui
        tree
      ];

      file = {
        neovim = {
          source = ../../programs/neovim;
          target = ".config/nvim";
          recursive = true;
        };
      };

      stateVersion = "23.05";
    };

    manual.manpages.enable = false;

    programs.fish = import ../../programs/fish.nix super // {
      shellInit = ''
        set -x PATH /opt/homebrew/bin /run/current-system/sw/bin /Users/landreussi/.nix-profile/bin $PATH
      '';
    };
    programs.git = import ../../programs/git.nix super;
    programs.gpg = import ../../programs/gpg.nix super;
    programs.kitty = import ../../programs/kitty.nix super;
    programs.neovim = import ../../programs/neovim.nix super;
    programs.ssh = import ../../programs/ssh.nix super;
    programs.tmux = import ../../programs/tmux.nix super;
    programs.home-manager.enable = true;
  };
  services.yabai = import ../../programs/yabai.nix super;
  services.skhd = import ../../programs/skhd.nix super;
}
