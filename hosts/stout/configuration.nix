{pkgs, ...}: {
  imports = [./hardware-configuration.nix ./home.nix];

  ########## Boot ##########
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelParams = ["acpi_enforce_resources=lax" "mem_sleep_default=deep" "acpi=force"];
    kernelModules = ["i2c-dev" "i2c-piix4"];
  };
  ########## Networking ##########
  networking = {
    hostName = "stout";
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 8080 8001];
    };

    interfaces.enp5s0.wakeOnLan.enable = true;
  };

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
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  services.xserver = {
    enable = true;
    xkb = {
      variant = "intl";
      options = "caps:escape";
    };
    videoDrivers = ["nvidia"];

    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [dmenu i3status i3lock];
    };

    displayManager.startx = {
      enable = true;
      generateScript = true;
      # Output of arandr:
      extraCommands = "xrandr --output HDMI-0 --mode 1920x1080 --pos 320x0 --output HDMI-1 --primary --mode 2560x1080 --rate 75 --pos 0x1080";
    };
  };

  ########## Sound ##########
  services.pipewire.enable = false;
  services.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; # Enables advanced BT codecs (AAC, aptX, aptX-HD, LDAC).
  };
  ########## Bluetooth ##########
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  ######### Global Programs ##########
  environment.systemPackages = with pkgs; [
    alsa-utils
    curl
    coreutils
    i2c-tools
    liquidctl
    xdg-utils
    xdg-user-dirs
    wget
  ];

  ########## Docker ##########
  virtualisation.docker = {
    enable = true;
    extraPackages = [pkgs.docker-compose];
    enableOnBoot = false;
  };

  ########## Fonts ##########
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font Mono"];
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
      };
    };

    packages = with pkgs; [
      font-awesome
      lmodern
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
  };

  ######### Utils #########
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.udisks2.enable = true;
  services.udev.enable = true;

  ###### Controllers ######
  hardware.i2c.enable = true;

  services.udev.packages = [pkgs.openrgb-with-all-plugins];

  ########## Nix ##########
  nix.settings = {
    substituters = ["https://nix-community.cachix.org" "https://cache.nixos-cuda.org"];
    trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
    experimental-features = ["nix-command" "flakes"];
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    permittedInsecurePackages = ["electron-39.8.10" "electron-40.10.5"];
  };

  # TODO: esp32 in rust depends on this, check if there is a way to not depend on this.
  programs.nix-ld.enable = true;
  system.stateVersion = "26.11";
}
