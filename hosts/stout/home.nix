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
        nixfmt-classic
        htop
        neofetch
        lazygit
        fd
        fzf
        go
        gh
        grpcurl
        logseq
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
        bluetui
        libreoffice
        obs-studio
        # C/C++
        gcc
        # Rust
        rust-analyzer
        sccache
        # TS/Node
        nodePackages.typescript-language-server
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
          target = "${home}/.config/nvim";
          recursive = true;
        };
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
        gattino-kitten = with pkgs; {
          source = pkgs.stdenv.mkDerivation {
            name = "gattino";
            src =
              fetchFromGitHub
              {
                owner = "salvozappa";
                repo = "gattino";
                rev = "main";
                sha256 = "sha256-YqSjWAsXH4wXhK/er/OhKb+gTXz8LGk2XKXSkJMtipk=";
              };
            postPatch = ''
              substituteInPlace gattino.config.json \
                  --replace-fail "/usr/local/bin/ollama" "${lib.getExe pkgs.ollama}"

            '';
            installPhase = ''
              runHook preInstall

              mkdir -p $out
              cp -r gattino.py gattino.config.json src $out/

              runHook postInstall
            '';
          };
          target = "${home}/.config/kitty/gattino";
        };
      };

      stateVersion = "25.11";
    };
    xdg = {
      enable = true;
      userDirs.enable = true;
    };

    manual.manpages.enable = false;
    programs.delta = import ../../programs/delta.nix;
    programs.fish =
      import ../../programs/fish.nix super
      // {
        shellInit = ''
          set -x PATH $PATH $HOME/.cargo/bin
          set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        '';
      };
    programs.git = import ../../programs/git.nix super;
    programs.helix = import ../../programs/helix.nix super;
    programs.kitty = import ../../programs/kitty.nix;
    programs.neovim = import ../../programs/neovim.nix super;
    programs.direnv = import ../../programs/direnv.nix super;
    programs.ssh = import ../../programs/ssh.nix;
    programs.gpg = import ../../programs/gpg.nix super;
    services.gpg-agent = import ../../services/gpg-agent.nix super;
    services.ollama.enable = true;
    systemd.user.services.ollama.Install = lib.mkForce {};
    programs.home-manager.enable = true;
  };

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };

  services.sunshine = {
    enable = true;
    autoStart = false;
    openFirewall = true;
  };
  environment.variables.EDITOR = "hx";

  users.users.landreussi = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = ["wheel" "docker"];
    name = user;
    home = home;
  };
}
