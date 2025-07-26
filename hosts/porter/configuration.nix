{ pkgs, ... }:

{
  imports = [ ./home.nix ];

  environment.darwinConfig = "$HOME/dotfiles/hosts/porter/configuration.nix";

  homebrew.casks = [ "brave-browser" "ledger-live" "logseq" "upscayl" ];

  homebrew.brews = [ "pinentry" ];

  fonts.packages = with pkgs; [
    font-awesome
    lmodern
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    enable = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  homebrew.enable = true;
  networking.computerName = "porter";
  system.stateVersion = 4;
}
