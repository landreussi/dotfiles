super @ {
  pkgs,
  lib,
  config,
  ...
}: let
  user = "landreussi";
  home = "/home/${user}";
  qwenChatTemplate = pkgs.fetchurl {
    url = "https://huggingface.co/froggeric/Qwen-Fixed-Chat-Templates/resolve/main/chat_template.jinja";
    hash = "sha256-xHyCsFRHUtRU9OQnIo2dnYw99kyeRGy9Aik2L2eUgAk=";
  };
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
        logseq
        obsidian
        pass
        tree
        scrot
        ripgrep
        xclip
        lxappearance
        feh
        gruvbox-dark-gtk
        adwaita-icon-theme
        spotify-player
        pavucontrol
        youtube-tui
        mpv
        bluetui
        libreoffice
        xdotool
        libnotify
        obs-studio
        llama-cpp
        codex
        claude-code
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
        nodejs
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
        '';
      };
    programs.git = import ../../programs/git.nix super;
    programs.helix = import ../../programs/helix.nix super;
    programs.kitty = import ../../programs/kitty.nix;
    programs.neovim = import ../../programs/neovim.nix;
    programs.direnv = import ../../programs/direnv.nix;
    programs.ssh = import ../../programs/ssh.nix;
    programs.gpg = import ../../programs/gpg.nix super;
    services.dunst = import ../../services/dunst.nix;
    services.gpg-agent = import ../../services/gpg-agent.nix super;

    systemd.user.services.llama-cpp = {
      Unit = {
        Description = "llama.cpp server";
        After = ["network.target"];
      };
      Service = {
        ExecStart = ''
          ${pkgs.llama-cpp}/bin/llama-server \
            --ctx-size 32768 \
            --cache-type-k q8_0 \
            --cache-type-v q8_0 \
            --hf-repo unsloth/Qwen3.5-9B-GGUF \
            --host 127.0.0.1 \
            --jinja \
            --chat-template-file ${qwenChatTemplate} \
            -ngl 99 \
            -fit on \
            --port 8001
        '';
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    programs.home-manager.enable = true;
  };

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    startupProfile = "${home}/.config/OpenRGB/theme.orp";
  };

  services.sunshine = {
    enable = true;
    autoStart = false;
    openFirewall = true;
    applications = {
      apps = [
        {
          name = "Cyberpunk 2077 1440p";

          prep-cmd = [
            {
              do = ''
                ${pkgs.xorgserver}/bin/Xvfb :99 -screen 0 2560x1440x24 -nolisten tcp &
              '';
              undo = ''
                ${pkgs.procps}/bin/pkill -f "Xvfb :99"
              '';
            }
          ];

          cmd = "DISPLAY=:99 ${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://rungameid/1091500";
          auto-detach = "true";
          exclude-global-prep-cmd = "false";
        }
        {
          name = "Steam Big Picture";

          prep-cmd = [
            {
              do = ''
                ${pkgs.xorgserver}/bin/Xvfb :99 -screen 0 2560x1440x24 -nolisten tcp &
              '';
              undo = ''
                ${pkgs.procps}/bin/pkill -f "Xvfb :99"
              '';
            }
          ];

          cmd = "DISPLAY=:99 ${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://open/bigpicture";
          auto-detach = "true";
          exclude-global-prep-cmd = "false";
        }
      ];
    };
  };

  systemd.user.services.sunshine.serviceConfig.ExecStart =
    lib.mkForce (lib.getExe config.services.sunshine.package);

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
