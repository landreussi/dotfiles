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
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  services.xserver = {
    enable = true;
    xkb.variant = "intl";
    videoDrivers = [ "nvidia" ];

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
      nerd-fonts.jetbrains-mono
    ];
  };
  ###### RGB (fps++) ######
  boot = {
    kernelParams = [ "acpi_enforce_resources=lax" ];
    kernelModules = [ "i2c-dev" "i2c-piix4" ];
    extraModprobeConfig = ''
      options nvidia NVreg_RegistryDwords="RMUseSwI2c=0x01;RMI2cSpeed=100"
      options nvidia NVreg_PreserveVideoMemoryAllocations=1
      options nvidia NVreg_TemporaryFilePath=/var/tmp
      options nvidia NVreg_DynamicPowerManagement=0x02
    '';
  };
  hardware.i2c.enable = true;
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = pkgs.openrgb.overrideAttrs (old: {
      src = pkgs.fetchFromGitLab {
        owner = "landreussi";
        repo = "OpenRGB";
        rev = "release_candidate_1.0rc1-9280d3d5";
        sha256 = "sha256-3RH4ddWA/GCY/p7jylRgVUn1lvlwvIEVw2gpYzkMMLk=";
      };
      # The postPatch in nixpkgs is meant for v0.9 of OpenRGB, but the upstream is
      # more like a 1.1-ish thing, and the udev rules script changed.
      postPatch = ''
        patchShebangs scripts/build-udev-rules.sh
        substituteInPlace scripts/build-udev-rules.sh \
          --replace-fail /usr/bin/env "${pkgs.coreutils}/bin/env"
      '';
    });
  };

  # Pull in changes from https://github.com/NixOS/nixpkgs/commit/63b416944c7821a13bd1aafb86d3df3de6765f0b
  # These two lines can be removed once we're on NixOS 25.11.
  systemd.services.openrgb.after = [ "network.target" ];
  systemd.services.openrgb.wants = [ "dev-usb.device" ];

  ########## Nix ##########
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config = {
    permittedInsecurePackages = [ "electron-27.3.11" "nix-2.15.3" ];
    allowUnfree = true;
  };
  system.stateVersion = "25.05";
}

