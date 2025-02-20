super@{ pkgs, config, lib, ... }:

{
  imports = [ <home-manager/nixos> ];

  nixpkgs.overlays = [
    # Rust analyzer overlay
    # TODO: make this a separated module
    (final: _: {
      rust-analyzer-unwrapped = final.stdenv.mkDerivation rec {
        pname = "rust-analyzer-unwrapped";
        version = "2024-09-16";
        src = builtins.fetchurl {
          url = "https://github.com/rust-lang/rust-analyzer/releases/download/${version}/rust-analyzer-x86_64-unknown-linux-gnu.gz";
          sha256 = "sha256:3d524eb3cb796109ccd09db2533382076070a26abe2cf338321fef527cc3cd9f";
        };

        dontUnpack = true;

        nativeBuildInputs = with final; [ gzip autoPatchelfHook ];
        buildInputs = with final; [ libgcc ];

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
      homeDirectory = "/home/landreussi";
      packages = with pkgs; [
        jq
        git
        brave
        nixfmt
        htop
        neofetch
        spotify-tui
        lazygit
        fd
        fzf
        go
        gh
        grpcurl
        logseq
        pass
        tree
        pinentry
        scrot
        ripgrep
        xclip
        libreoffice
        # C/C++
        gcc
        # Rust
        rust-analyzer
        sccache
        # TS/Node
        nodePackages.typescript-language-server
        yarn
        # Needed for copilot (OH GOD WHY, WHYYYYYYY?)
        nodejs
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
          target = "/home/landreussi/.config/nvim";
          recursive = true;
        };
        i3 = {
          source = ../../programs/i3;
          target = "/home/landreussi/.config/i3";
        };
        i3status = {
          source = ../../programs/i3status;
          target = "/home/landreussi/.config/i3status";
        };
        bg = {
          source = ./.background-image;
          target = "/home/landreussi/.background-image";
        };
      };

      stateVersion = "23.11";
    };
    xdg = {
      enable = true;
      userDirs.enable = true;
    };

    manual.manpages.enable = false;
    services.spotifyd = import ../../programs/spotifyd.nix super;

    programs.fish = import ../../programs/fish.nix super // {
      shellInit = ''
        set -x PATH $HOME/.cargo/bin $PATH
      '';
    };
    programs.git = import ../../programs/git.nix super;
    programs.gpg = import ../../programs/gpg.nix super;
    programs.kitty = import ../../programs/kitty.nix super // {
      # TODO: solve this code duplication :cry:
      settings =
        let
          family = "JetBrainsMono Nerd Font";
          fontWithStyle = style: family + " " + style;
        in
        {
          font_family = family;
          bold_font = fontWithStyle "Bold";
          italic_font = fontWithStyle "Italic";
          bold_italic_font = fontWithStyle "Bold Italic";
          font_size = 14;

          scrollback_lines = 1000;
          mouse_hide_wait = -1;
          url_style = "straight";
          enabled_layouts = "horizontal";

          tab_bar_margin_width = 0;
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          tab_bar_align = "center";
          tab_title_template =
            "{index} {tab.active_exe.replace('-', '')} {tab.active_wd.split('/')[-1]}";
        };
    };
    programs.neovim = import ../../programs/neovim.nix super;
    programs.ssh = import ../../programs/ssh.nix super;
    programs.direnv = import ../../programs/direnv.nix super;
    programs.home-manager.enable = true;
  };

  users.users.landreussi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    name = "landreussi";
    home = "/home/landreussi";
  };
}
