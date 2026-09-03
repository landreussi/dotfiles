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

  # Generates /etc/fish/config.fish, which sources the nix-darwin environment
  # (PATH, NIX_PROFILES, NIX_SSL_CERT_FILE) into fish. Without it fish never
  # sees the system profile, which is what the old fenv/nix-daemon.sh dance in
  # programs/fish.nix was working around.
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

  # Lets `darwin-rebuild switch` find the flake with no arguments: it resolves
  # this symlink and uses the containing directory, defaulting the attribute to
  # LocalHostName (which nix-darwin sets from networking.computerName).
  environment.etc."nix-darwin/flake.nix".source = "/Users/landreussi/dotfiles/flake.nix";

  system.primaryUser = "landreussi";
  networking.computerName = "porter";
  system.stateVersion = 4;
}
