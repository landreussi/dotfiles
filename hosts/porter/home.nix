super @ {pkgs, ...}: {
  imports = [<home-manager/nix-darwin>];
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
        grpcurl
        htop
        jq
        lazygit
        nixfmt
        fastfetch
        pass
        ripgrep
        spotify-player
        tree
        wget
        gcc
        # Docker
        colima
        docker
        # Rust
        rust-analyzer
        sccache
        # TS/Node
        nodejs
        typescript-language-server
        yarn
        # Python
        pyright
        # Nix
        nixd
        # Lua
        lua-language-server
      ];

      file = {
        neovim = {
          source = ../../programs/neovim/nvchad;
          target = ".config/nvim";
          recursive = true;
        };
      };

      stateVersion = "25.05";
    };

    manual.manpages.enable = false;

    programs.fish =
      import ../../programs/fish.nix super
      // {
        shellInit = ''
          set -x PATH $PATH /opt/homebrew/bin /run/current-system/sw/bin $HOME/.cargo/bin
        '';
      };
    programs.git = import ../../programs/git.nix super;
    programs.gpg = import ../../programs/gpg.nix super;
    programs.kitty = import ../../programs/kitty.nix;
    programs.neovim = import ../../programs/neovim.nix;
    programs.ssh = import ../../programs/ssh.nix;
    programs.helix = import ../../programs/helix.nix super;
    programs.direnv = import ../../programs/direnv.nix;
    programs.aerospace = import ../../programs/aerospace.nix super;
    programs.home-manager.enable = true;
  };
}
