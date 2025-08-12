{ pkgs, ... }:

{
  imports = [ ./home.nix ];

  environment.darwinConfig =
    "/Users/landreussi/dotfiles/hosts/porter/configuration.nix";

  homebrew.casks = [ "brave-browser" "ledger-live" "logseq" "upscayl" ];

  homebrew.brews = [ "pinentry" ];

  fonts.packages = with pkgs; [
    font-awesome
    lmodern
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
  ];

  nix = {
    package = pkgs.nix;
    enable = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  networking.computerName = "porter";
  system.stateVersion = 4;
}
