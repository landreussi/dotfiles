super @ {pkgs, ...}: {
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
        nil
        # Lua
        lua-language-server
      ];

      # Prepended to PATH for every shell home-manager manages, instead of being
      # hammered in by fish's shellInit. The system profile arrives via
      # nix-darwin's programs.fish.
      sessionPath = [
        "/opt/homebrew/bin"
        "$HOME/.cargo/bin"
      ];

      stateVersion = "25.05";
    };

    manual.manpages.enable = false;

    programs.fish = import ../../programs/fish.nix super;
    programs.git = import ../../programs/git.nix super;
    programs.gpg = import ../../programs/gpg.nix super;
    programs.kitty = import ../../programs/kitty.nix;
    programs.firefox = import ../../programs/firefox.nix (super // {bottomToolbox = true;});
    programs.nvchad = import ../../programs/nvchad.nix super;
    programs.ssh = import ../../programs/ssh.nix;
    programs.helix = import ../../programs/helix.nix super;
    programs.direnv = import ../../programs/direnv.nix;
    programs.aerospace = import ../../programs/aerospace.nix super;
    programs.home-manager.enable = true;
  };
}
