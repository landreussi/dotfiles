# Options and command construction shared by the NixOS and home-manager
# modules. The daemon is the same in both; only the systemd scope differs.
{lib}: let
  inherit (lib) mkOption types;
in rec {
  mkOptions = {pkgs}: {
    enable = lib.mkEnableOption "the Spotify Soloist headless player";

    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ./package.nix {};
      defaultText = lib.literalExpression "soloist";
      description = "The soloist package to run.";
    };

    deviceName = mkOption {
      type = types.str;
      example = "Kitchen speaker";
      description = "Name advertised over Spotify Connect (`--device-name`).";
    };

    apiKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/etc/soloist/api-key";
      description = ''
        File holding the Soloist API key generated at
        <https://developer.spotify.com/dashboard/soloist>. It reaches the unit
        through systemd's credential store, so the key never lands in the Nix
        store. Mutually exclusive with `apiKeyCommand`.
      '';
    };

    apiKeyCommand = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      example = lib.literalExpression ''["''${lib.getExe pkgs.pass}" "soloist"]'';
      description = ''
        Command run at start-up whose first line of output is the API key, for
        keys kept in a password manager rather than a plain file. Mutually
        exclusive with `apiKeyFile`.

        The command runs in the unit's own environment, so anything it needs
        (a gpg-agent with the key unlocked, for instance) has to be reachable
        from there. If it is not, the unit fails and is retried.
      '';
    };

    pipewireDevice = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "PipeWire node name or id to play through (`--pipewire-device`). Null uses the system default.";
    };

    initialVolume = mkOption {
      type = types.nullOr (types.ints.between 0 100);
      default = null;
      description = "Volume to start at (`--initial-volume`). Null keeps whatever the audio system reports.";
    };

    cacheSizeMB = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      description = "Playback cache ceiling in MB (`--cache-size`). 0 means no limit; any other value must be at least 100.";
    };

    dataDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override for the persistent state directory (`--data-dir`). Null leaves it to systemd's StateDirectory.";
    };

    cacheDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override for the cache directory (`--cache-dir`). Null leaves it to systemd's CacheDirectory.";
    };

    singleTrack = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "spotify:track:4cOdK2wGLETKBW3PvgPWqT";
      description = "Play one URI and exit (`--single-track`). Turns the unit into a one-shot player.";
    };

    websocket = {
      enable = lib.mkEnableOption "the local WebSocket control API (`--ws`)";

      listen = mkOption {
        type = types.str;
        default = "127.0.0.1:4141";
        description = "Address and port the WebSocket API binds to. `soloist ctl` finds it through the data directory, so a loopback bind is usually enough.";
      };
    };

    verbose = mkOption {
      type = types.bool;
      default = false;
      description = "Pass `--verbose` for full logs.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra arguments appended to the soloist command line.";
    };
  };

  mkAssertions = cfg: [
    {
      assertion = cfg.cacheSizeMB == null || cfg.cacheSizeMB == 0 || cfg.cacheSizeMB >= 100;
      message = "services.soloist.cacheSizeMB must be 0 (no limit) or at least 100.";
    }
    {
      assertion = (cfg.apiKeyFile == null) != (cfg.apiKeyCommand == null);
      message = "services.soloist needs exactly one of apiKeyFile or apiKeyCommand.";
    }
  ];

  mkArgs = cfg:
    ["--device-name" cfg.deviceName]
    ++ lib.optionals (cfg.pipewireDevice != null) ["--pipewire-device" cfg.pipewireDevice]
    ++ lib.optionals (cfg.initialVolume != null) ["--initial-volume" (toString cfg.initialVolume)]
    ++ lib.optionals (cfg.cacheSizeMB != null) ["--cache-size" (toString cfg.cacheSizeMB)]
    ++ lib.optionals (cfg.dataDir != null) ["--data-dir" cfg.dataDir]
    ++ lib.optionals (cfg.cacheDir != null) ["--cache-dir" cfg.cacheDir]
    ++ lib.optionals (cfg.singleTrack != null) ["--single-track" cfg.singleTrack]
    ++ lib.optionals cfg.websocket.enable ["--ws" cfg.websocket.listen]
    ++ lib.optional cfg.verbose "--verbose"
    ++ cfg.extraArgs;

  # The key is fetched at start-up rather than written into the unit file,
  # which would put it in the store. Upstream takes it only as an argv flag, so
  # it is still visible in the running process' command line either way.
  mkStartScript = {
    pkgs,
    cfg,
  }:
    pkgs.writeShellScript "soloist-start" ''
      set -euo pipefail
      ${
        if cfg.apiKeyCommand != null
        then ''
          api_key=$(${lib.escapeShellArgs cfg.apiKeyCommand})
          # Password managers print the secret on the first line and may print
          # metadata after it. Trimmed in the shell rather than piped through
          # head, which would race pipefail against SIGPIPE.
          api_key=''${api_key%%$'\n'*}''
        else ''api_key=$(<"$CREDENTIALS_DIRECTORY/api-key")''
      }
      exec ${lib.getExe cfg.package} \
        --api-key "$api_key" \
        ${lib.escapeShellArgs (mkArgs cfg)}
    '';

  # LoadCredential is only meaningful for the file-backed path.
  mkCredentials = cfg: lib.optional (cfg.apiKeyFile != null) "api-key:${cfg.apiKeyFile}";
}
