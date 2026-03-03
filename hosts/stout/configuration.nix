{pkgs, ...}: {
  imports = [./hardware-configuration.nix ./home.nix];

  ###### RGB (fps++) ######
  hardware.i2c.enable = true;
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins.overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          (pkgs.fetchpatch {
            url = "https://gitlab.com/CalcProgrammer1/OpenRGB/-/commit/f2c1f85b2faf116a71875cc1a341d8becbe472f8.patch";
            hash = "sha256-457tUE7R7LO2yhLbYpoY/j1DcpQIc6UHgrzcMXa8nxk=";
          })
        ];
      postPatch = ''
        patchShebangs scripts/build-udev-rules.sh
        substituteInPlace scripts/build-udev-rules.sh \
          --replace-fail "/bin/env chmod" "${pkgs.coreutils}/bin/chmod"
      '';
    });
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
  networking = {
    hostName = "stout";
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80];
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

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
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
  hardware.pulseaudio.enable = false;

  # Enable PipeWire
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-bluez.conf" = {
          "monitor.bluez.properties" = {
            "bluez5.codecs" = [
              "sbc"
              "sbc_xq"
              "aac"
              "ldac"
              "aptx"
              "aptx_hd"
              "aptx_ll"
              "aptx_ll_duplex"
              "faststream"
              "faststream_duplex"
            ];
            "bluez5.enable-msbc" = true;
            "bluez5.enable-sbc-xq" = true;
            "bluez5.roles" = [
              "a2dp_sink"
              "a2dp_source"
              "hfp_hf"
              "hfp_ag"
              "hsp_hs"
              "hsp_ag"
            ];
          };
        };
      };
    };
  };
  ########## Bluetooth ##########
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
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
  services.udev.enable = true;

  ########## Nix ##########
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config = {
    permittedInsecurePackages = ["electron-27.3.11" "nix-2.15.3"];
    allowUnfree = true;
    cudaSupport = true;
  };
  system.stateVersion = "26.05";
}
