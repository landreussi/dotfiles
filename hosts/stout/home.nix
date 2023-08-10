super@{ pkgs, config, ... }:

{
  imports = [ <home-manager/nixos> ];

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
        pass
        tree
        pinentry
        scrot
        ripgrep
        # C/C++
        gcc
        # Rust
        rust-analyzer
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
        # Solana
        solana-cli
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

      stateVersion = "23.05";
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
    programs.git = import ../../programs/git.nix super // {
      extraConfig.core.sshCommand = "ssh -i ~/.ssh/stout";
    };
    programs.gpg = import ../../programs/gpg.nix super;
    programs.kitty = import ../../programs/kitty.nix super // {
      # TODO: solve this code duplication :cry:
      settings = let
        family = "JetBrainsMono Nerd Font";
        fontWithStyle = style: family + " " + style;
      in {
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
    programs.ssh = import ../../programs/ssh.nix super // {
      matchBlocks.identityFile =
        "${config.users.users.landreussi.home}/.ssh/stout";
    };
    programs.home-manager.enable = true;
  };

  users.users.landreussi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    name = "landreussi";
    home = "/home/landreussi";
  };
}
