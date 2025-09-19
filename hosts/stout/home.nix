super@{ pkgs, ... }:

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
        # Needed for copilot (OH GOD WHY, WHYYYYYYY?)
        nodejs
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

      stateVersion = "25.05";
    };
    xdg = {
      enable = true;
      userDirs.enable = true;
    };

    manual.manpages.enable = false;
    programs.fish = import ../../programs/fish.nix super // {
      shellInit = ''
        set -x PATH $PATH $HOME/.cargo/bin 
        set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        if not set -q DISPLAY; and test "$(tty)" = /dev/tty1
            exec startx
        end
      '';
    };
    programs.git = import ../../programs/git.nix super;
    programs.kitty = import ../../programs/kitty.nix;
    programs.neovim = import ../../programs/neovim.nix super;
    programs.direnv = import ../../programs/direnv.nix super;
    programs.ssh = import ../../programs/ssh.nix;
    programs.gpg = import ../../programs/gpg.nix super;
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableFishIntegration = true;
      pinentry = { package = pkgs.pinentry-curses; };
    };
    programs.home-manager.enable = true;
  };
  services.ollama = {
    enable = true;
    loadModels = [ "gemma2" ];
    acceleration = "cuda";
  };
  services.udisks2.enable = true;
  services.fwupd.enable = true;

  users.users.landreussi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    name = "landreussi";
    home = "/home/landreussi";
  };
}
