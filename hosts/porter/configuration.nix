{pkgs, ...}: {
  imports = [./home.nix];

  homebrew.casks = [
    "brave-browser"
    "ledger-live"
    "logseq"
    "upscayl"
    "mounty"
  ];
  homebrew.brews = ["pinentry"];
  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    font-awesome
    lmodern
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  nix = {
    package = pkgs.nix;
    enable = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  ids.gids.nixbld = 350;

  environment.etc."nix-darwin/flake.nix".source = "/Users/landreussi/dotfiles/flake.nix";
  environment.darwinConfig = "/Users/landreussi/dotfiles/hosts/porter/configuration.nix";
  system.primaryUser = "landreussi";
  networking.computerName = "porter";
  system.stateVersion = 4;
}
