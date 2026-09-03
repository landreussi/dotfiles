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
        nil
        nixfmt
        # Lua
        lua-language-server
      ];

      file = {
        bg = {
          source = ./.background-image;
          target = "${home}/.background-image";
        };
      };

      sessionPath = ["$HOME/.cargo/bin"];

      stateVersion = "26.11";
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
    programs.fish = import ../../programs/fish.nix super;
    programs.git = import ../../programs/git.nix super;
    programs.helix = import ../../programs/helix.nix super;
    programs.kitty = import ../../programs/kitty.nix;
    programs.firefox = import ../../programs/firefox.nix (super // {bottomToolbox = true;});
    programs.nvchad = import ../../programs/nvchad.nix super;
    programs.direnv = import ../../programs/direnv.nix;
    programs.ssh = import ../../programs/ssh.nix;
    programs.gpg = import ../../programs/gpg.nix super;
    programs.i3status-rust = import ../../programs/i3status-rust.nix;
    xsession.windowManager.i3 = import ../../programs/i3.nix super;
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

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    startupProfile = "theme";
  };

  # The upstream module runs openrgb as a long-lived SDK server. We only want it
  # to apply the profile once at boot and exit, so drop --server and turn the
  # unit into a oneshot. Profile name resolves inside /var/lib/OpenRGB.
  systemd.services.openrgb.serviceConfig = let
    cfg = config.services.hardware.openrgb;
  in {
    Type = "oneshot";
    RemainAfterExit = true;
    ExecStart = lib.mkForce (lib.escapeShellArgs [
      (lib.getExe cfg.package)
      "--profile"
      cfg.startupProfile
    ]);
    Restart = lib.mkForce "no";
  };

  programs.steam = {
    enable = true;
    protontricks.enable = true;
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
    extraGroups = ["wheel" "docker" "dialout" "i2c"];
    name = user;
    home = home;
  };
}
