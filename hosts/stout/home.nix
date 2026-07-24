super @ {
  pkgs,
  lib,
  ...
}: let
  user = "landreussi";
  home = "/home/${user}";
in {
  imports = [<home-manager/nixos>];

  home-manager.users.landreussi = {
    home = {
      username = user;
      homeDirectory = home;
      packages = with pkgs; [
        jq
        git
        brave
        btop
        fastfetch
        lazygit
        fd
        fzf
        go
        gh
        grpcurl
        # logseq
        pass
        tree
        scrot
        ripgrep
        xclip
        lxappearance
        feh
        gruvbox-material-gtk-theme
        adwaita-icon-theme
        spotify-player
        pavucontrol
        youtube-tui
        mpv
        bluetui
        libreoffice
        xdotool
        obs-studio
        obs-cmd
        codex
        claude-code
        jetbrains.idea-oss
        jetbrains.rust-rover
        zed-editor
        obsidian
        unzip
        gimp-with-plugins
        discord
        concord-tui
        winboat
        tailscale
        # C/C++
        gcc
        # Rust
        rust-analyzer
        sccache
        # TS/Node
        typescript-language-server
        vue-language-server
        yarn
        # Python
        pyright
        # Nix
        nixd
        nixfmt
        # Lua
        lua-language-server
      ];

      file = {
        i3 = {
          source = ../../programs/i3;
          target = "${home}/.config/i3";
        };
        i3status = {
          source = ../../programs/i3status;
          target = "${home}/.config/i3status";
        };
        bg = {
          source = ./.background-image;
          target = "${home}/.background-image";
        };
        nvchad = {
          source = pkgs.fetchFromGitHub {
            owner = "NvChad";
            repo = "starter";
            rev = "main";
            sha256 = "sha256-xdLr6tlU9uA+wu0pqha2br0fdVm+1MjgjbB5awz9ICU=";
          };
          target = "${home}/.config/nvim";
        };
      };

      stateVersion = "25.11";
    };
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        setSessionVariables = true;
      };
    };

    manual.manpages.enable = false;
    programs.delta = import ../../programs/delta.nix;
    programs.fish =
      import ../../programs/fish.nix super
      // {
        shellInit = ''
          set -x PATH $PATH $HOME/.cargo/bin
          set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket) > /dev/null
        '';
      };
    programs.git = import ../../programs/git.nix super;
    programs.helix = import ../../programs/helix.nix super;
    programs.kitty = import ../../programs/kitty.nix;
    programs.neovim = import ../../programs/neovim.nix;
    programs.direnv = import ../../programs/direnv.nix;
    programs.ssh = import ../../programs/ssh.nix;
    programs.gpg = import ../../programs/gpg.nix super;
    services.gpg-agent = import ../../services/gpg-agent.nix super;

    services.ollama.enable = true;
    systemd.user.services.ollama.Install = lib.mkForce {};

    programs.home-manager.enable = true;
  };

  environment.variables = {
    EDITOR = "hx";
    XCURSOR_SIZE = "16";
  };

  users.users.landreussi = {
    isNormalUser = true;
    useDefaultShell = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "docker" "dialout"];
    name = user;
    home = home;
  };
}
