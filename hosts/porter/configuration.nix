{ config, pkgs, ... }:

{
  imports = [ ./home.nix ];

  environment.darwinConfig = "$HOME/dotfiles/hosts/porter/configuration.nix";

  homebrew.casks = [ "brave-browser" "ledger-live" "logseq" ];

  homebrew.brews = [ "spotifyd" "pinentry" ];

  launchd.user.agents = {
    "spotifyd" = {
      serviceConfig = {
        ProgramArguments = [
          "/opt/homebrew/opt/spotifyd/bin/spotifyd"
          "--initial-volume=100"
          "--volume-normalisation"
          "--bitrate=320"
          "--backend=portaudio"
          "--volume-controller=soft-volume"
          "--device-type=computer"
          "--device-name=porter"
          "--no-daemon"
        ];
        KeepAlive = true;
        ThrottleInterval = 30;
      };
    };
  };

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
