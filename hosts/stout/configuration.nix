{ config, pkgs, ... }:

let
  openrgb = pkgs.openrgb.overrideAttrs (old: {
    src = pkgs.fetchFromGitLab {
      owner = "landreussi";
      repo = "OpenRGB";
      rev = "release_candidate_1.0rc1-9280d5";
      sha256 = "sha256-3RH4ddWA/GCY/p7jylRgVUn1lvlwvIEVw2gpYzkMMLk=";
    };
    postPatch = ''
      patchShebangs scripts/build-udev-rules.sh
      substituteInPlace scripts/build-udev-rules.sh \
        --replace-fail /usr/bin/env "${pkgs.coreutils}/bin/env"
    '';
  });
in {
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
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
  };

  systemd.sleep.extraConfig = "SuspendState=freeze";

  services.xserver = {
    enable = true;
    xkb.variant = "intl";
    videoDrivers = [ "nvidia" ];

    displayManager.startx = {
      enable = true;
      generateScript = true;
    };

    desktopManager.xterm.enable = false;
    windowManager.i3.enable = true;
    xrandrHeads = [{
      output = "HDMI-0";
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
    i2c-tools
    liquidctl
    xdg-utils
    xdg-user-dirs
    wget
  ];

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
      nerd-fonts.jetbrains-mono
    ];
  };
  ###### RGB (fps++) ######
  boot = {
    kernelParams = [ "acpi_enforce_resources=lax" ];
    kernelModules = [ "i2c-dev" "i2c-piix4" ];
  };
  hardware.i2c.enable = true;

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = openrgb;
  };

  systemd.services.openrgb = {
    after = [ "network.target" "systemd-suspend.service" ];
    wants = [ "dev-usb.device" ];
    wantedBy = [ "multi-user.target" "systemd-suspend.service" ];
    serviceConfig = {
      ExecStartPost = ''
        ${openrgb}/bin/openrgb --profile tokio
      '';
    };
  };

  ########## Nix ##########
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config = {
    permittedInsecurePackages = [ "electron-27.3.11" "nix-2.15.3" ];
    allowUnfree = true;
  };
  system.stateVersion = "25.05";
}

