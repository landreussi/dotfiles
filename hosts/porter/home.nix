super@{ config, pkgs, homebrew, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  users.users.landreussi = {
    name = "landreussi";
    home = "/Users/landreussi";
  };

  nixpkgs.overlays = [
    # Rust analyzer overlay
    # TODO: make this a separated module
    (final: _: {
      rust-analyzer-unwrapped = final.stdenv.mkDerivation rec {
        pname = "rust-analyzer-unwrapped";
        version = "2024-03-18";
        src = builtins.fetchurl {
          url = "https://github.com/rust-lang/rust-analyzer/releases/download/${version}/rust-analyzer-aarch64-apple-darwin.gz";
          sha256 = "sha256:0691y3q0d20bvybvn9i7l62v019g45wq8pjqrl2gmwqravjchbjn";
        };

        dontUnpack = true;

        nativeBuildInputs = with final; [ gzip ];
        buildInputs = with final; [ gcc ];

        doInstallCheck = true;
        installCheckPhase = ''
          runHook preInstallCheck
          versionOutput="$($out/bin/rust-analyzer --version)"
          echo "'rust-analyzer --version' returns: $versionOutput"
          runHook postInstallCheck
        '';

        buildPhase = ''
          runHook preBuild
          mkdir -p $out/bin
          gzip -c -d $src > $out/bin/rust-analyzer
          chmod +x $out/bin/rust-analyzer
          runHook postBuild
        '';
      };
    }
    )
  ];

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
        neofetch
        pass
        ripgrep
        spotify-tui
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
        nodePackages.typescript-language-server
        yarn
        # Python
        nodePackages.pyright
        # Nix
        rnix-lsp
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

      stateVersion = "23.11";
    };

    manual.manpages.enable = false;

    programs.fish = import ../../programs/fish.nix super // {
      shellInit = ''
        set -x PATH $PATH /opt/homebrew/bin /run/current-system/sw/bin $HOME/.cargo/bin 
      '';
    };
    programs.git = import ../../programs/git.nix super;
    programs.gpg = import ../../programs/gpg.nix super;
    programs.kitty = import ../../programs/kitty.nix super;
    programs.neovim = import ../../programs/neovim.nix super;
    programs.ssh = import ../../programs/ssh.nix super;
    programs.direnv = import ../../programs/direnv.nix super;
    programs.home-manager.enable = true;
  };
  services.yabai = import ../../programs/yabai.nix super;
  services.skhd = import ../../programs/skhd.nix super;
}
