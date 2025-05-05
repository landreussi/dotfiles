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
  hardware.nvidia.nvidiaSettings = true;
  hardware.graphics.enable = true;
  services.xserver = {
    enable = true;
    xkb.variant = "intl";

    displayManager.lightdm = {
      enable = true;
      background = ./.background-image;
      greeters.gtk = {
        enable = true;
        theme.name = "Adwaita-dark";
      };
    };

    desktopManager.xterm.enable = false;
    windowManager.i3.enable = true;
    xrandrHeads = [{
      output = "HDMI-2";
      primary = true;
    }];
  };

  ########## Sound ##########
  services.pipewire = { 
    enable = true;
    alsa.enable = true;
  };
  ########## Bluetooth ##########
  hardware.bluetooth.enable = true;

  ########## Global Programs ##########
  environment.systemPackages = with pkgs; [
    alsa-utils
    curl
    coreutils
    docker-compose
    lxappearance
    xdg-utils
    xdg-user-dirs
    xclip
    wget
  ];
  programs.gnupg.agent.enable = true;

  ########## Docker ##########
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  ########## Fonts ##########
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
      };
    };

    packages = with pkgs; [
      font-awesome
      lmodern
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  ########## Nix ##########
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
    "nix-2.15.3"
  ];
  system.stateVersion = "24.11";
}

