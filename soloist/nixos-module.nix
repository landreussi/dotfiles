{
  config,
  lib,
  pkgs,
  ...
}: let
  shared = import ./service.nix {inherit lib;};
  cfg = config.services.soloist;
in {
  options.services.soloist =
    shared.mkOptions {inherit pkgs;}
    // {
      user = lib.mkOption {
        type = lib.types.str;
        default = "soloist";
        description = "User the daemon runs as. The default user is created and put in the audio group.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "soloist";
        description = "Group the daemon runs as.";
      };
    };

  config = lib.mkIf cfg.enable {
    assertions = shared.mkAssertions cfg;

    users.users = lib.mkIf (cfg.user == "soloist") {
      soloist = {
        isSystemUser = true;
        group = cfg.group;
        # PipeWire and PulseAudio device nodes are group-owned by audio.
        extraGroups = ["audio"];
        description = "Spotify Soloist daemon";
      };
    };

    users.groups = lib.mkIf (cfg.group == "soloist") {soloist = {};};

    systemd.services.soloist = {
      description = "Spotify Soloist headless player";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target" "sound.target"];

      serviceConfig = {
        ExecStart = shared.mkStartScript {inherit pkgs cfg;};
        User = cfg.user;
        Group = cfg.group;
        LoadCredential = shared.mkCredentials cfg;
        # soloist reads $STATE_DIRECTORY and $CACHE_DIRECTORY when --data-dir
        # and --cache-dir are not given.
        StateDirectory = "soloist";
        CacheDirectory = "soloist";
        Restart = "on-failure";
        RestartSec = 5;
        # Exit 10 means the build is past its 90-day expiry. Restarting cannot
        # fix that, so fail loudly instead of looping.
        RestartPreventExitStatus = [10];
      };
    };
  };
}
