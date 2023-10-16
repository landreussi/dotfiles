{ config, pkgs, ... }:

{
  imports = [ ./home.nix ];

  environment.darwinConfig = "$HOME/dotfiles/hosts/porter/configuration.nix";

  homebrew.casks = [ "brave-browser" "ledger-live" ];

  homebrew.brews = [ "spotifyd" "pinentry" ];

  launchd.user.agents = {
    "spotifyd" = {
      serviceConfig = {
        ProgramArguments = [
          "/opt/homebrew/opt/spotifyd/bin/spotifyd"
          "--username=landreussi"
          "--password-cmd=pass spotify"
          "--initial-volume=100"
          "--volume-normalisation"
          "--bitrate=320"
          "--backend=portaudio"
          "--volume-controller=softvol"
          "--device-type=computer"
          "--device-name=porter"
          "--no-daemon"
        ];
        KeepAlive = true;
        ThrottleInterval = 30;
      };
    };
  };

  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      font-awesome
      lmodern
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  homebrew.enable = true;
  networking.computerName = "porter";
  system.stateVersion = 4;
}
