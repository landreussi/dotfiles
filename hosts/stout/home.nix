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
        blueman
        spotify-tui
        lazygit
        fd
        fzf
        go
        gcc
        pass
        tree
        pinentry
      ];

      file = {
        neovim = {
          source = ../../programs/neovim/nvchad;
          target = "/home/landreussi/.config/nvim";
          recursive = true;
        };
        i3status = {
          source = ../../programs/i3status;
          target = "/home/landreussi/.config/i3status";
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

    programs.fish = import ../../programs/fish.nix super;
    programs.git = import ../../programs/git.nix super // {
      extraConfig.core.sshCommand = "ssh -i ~/.ssh/stout";
    };
    programs.gpg = import ../../programs/gpg.nix super;
    programs.kitty = import ../../programs/kitty.nix super // {
      settings.font_size = 15;
    };
    programs.neovim = import ../../programs/neovim.nix super;
    programs.ssh = import ../../programs/ssh.nix super // {
      matchBlocks.identityFile =
        "${config.users.users.landreussi.home}/.ssh/stout";
    };
    programs.tmux = import ../../programs/tmux.nix super;
    programs.home-manager.enable = true;
  };

  users.users.landreussi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    name = "landreussi";
    home = "/home/landreussi";
  };
}
