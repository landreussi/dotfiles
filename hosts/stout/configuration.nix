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
    package = config.boot.kernelPackages.nvidiaPackages.latest;
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

    displayManager.startx = {
      enable = true;
      generateScript = true;
    };

    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [dmenu i3status i3-resurrect];
    };
    xrandrHeads = [
      {
        output = "HDMI-1";
        primary = true;
      }
    ];
  };

  ########## Sound ##########
  services.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  # me and my homies hates pipewire and wireplumber!
  services.pipewire.enable = false;
  ########## Bluetooth ##########
  hardware.bluetooth.enable = true;

  ########## Global Programs ##########
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
    extraPackages = with pkgs; [docker-compose];
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

  ########## Nix ##########
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config = {
    permittedInsecurePackages = ["electron-27.3.11" "nix-2.15.3"];
    allowUnfree = true;
    cudaSupport = true;
  };
  system.stateVersion = "25.11";
}
