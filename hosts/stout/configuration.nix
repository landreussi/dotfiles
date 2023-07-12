{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./home.nix ];

  ########## Boot ##########
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ########## Networking ##########
  networking.hostName = "stout";
  networking.firewall.enable = true;

  ########## TZ ##########
  time.timeZone = "America/Sao_Paulo";

  ########## Console ##########
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  ########## Video ##########
  hardware.nvidia.package =
    config.boot.kernelPackages.nvidiaPackages.legacy_470;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  services.xserver = {
    enable = true;
    xkbVariant = "intl";

    displayManager.startx.enable = true;
    desktopManager.xterm.enable = false;
    windowManager.i3.enable = true;
    xrandrHeads = [{
      output = "HDMI-2";
      primary = true;
    }];
  };

  ########## Sound ##########
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  ########## Bluetooth ##########
  hardware.bluetooth.enable = true;

  ########## Global Programs ##########
  environment.systemPackages = with pkgs; [
    curl
    coreutils
    lxappearance
    xdg_utils
    xdg-user-dirs
    xclip
    wget
  ];
  programs.gnupg.agent.enable = true;

  ########## Fonts ##########
  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
      };
    };

    fonts = with pkgs; [
      font-awesome
      lmodern
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  ########## Nixpkgs version ##########
  system.stateVersion = "23.05";
}

