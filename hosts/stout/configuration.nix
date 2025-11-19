{
  config,
  pkgs,
  ...
}: let
  openrgb = pkgs.openrgb-with-all-plugins.overrideAttrs (old: {
    src = pkgs.fetchFromGitLab {
      owner = "landreussi";
      repo = "OpenRGB";
      rev = "release_candidate_1.0rc1-9280d3d5";
      sha256 = "sha256-LxiuoniXaR5BlNGYkRhOKLHHdq7VPRPHrUOXWOwMnTE=";
    };
    patches = [];
    postPatch = ''
      patchShebangs scripts/build-udev-rules.sh
      substituteInPlace scripts/build-udev-rules.sh \
        --replace-fail "/bin/env chmod" "${pkgs.coreutils}/bin/chmod"
    '';
  });
in {
  imports = [./hardware-configuration.nix ./home.nix];

  ###### RGB (fps++) ######
  hardware.i2c.enable = true;
  systemd.services.openrgb = {
    after = ["network.target"];
    wants = ["dev-usb.device"];
    wantedBy = ["multi-user.target" "systemd-suspend.service"];
    serviceConfig = {
      ExecStart = "${openrgb}/bin/openrgb --server --server-port 6742 --profile /home/landreussi/.config/OpenRGB/theme.orp";
      Restart = "always";
      StateDirectory = "OpenRGB";
      WorkingDirectory = "/var/lib/OpenRGB";
    };
  };

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
  networking.hostName = "stout";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
    ];
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
    open = true;
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
      extraPackages = with pkgs; [dmenu i3status i3-resurrect];
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
    support32Bit = true;
  };
  ########## Bluetooth ##########
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  ######### Global Programs ##########
  environment.systemPackages = with pkgs;
    [
      alsa-utils
      curl
      coreutils
      i2c-tools
      liquidctl
      xdg-utils
      xdg-user-dirs
      wget
      nvtopPackages.nvidia
    ]
    ++ [openrgb];

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
  services.udev = {
    enable = true;
    extraRules = ''
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="1b8e", ATTR{idProduct}=="c003", MODE:="0666", SYMLINK+="worldcup"
    '';
  };

  ########## Nix ##########
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config = {
    permittedInsecurePackages = ["electron-27.3.11" "nix-2.15.3"];
    allowUnfree = true;
    cudaSupport = true;
  };
  system.stateVersion = "26.05";
}
