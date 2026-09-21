{
  config,
  lib,
  pkgs,
  ...
}: let
  shared = import ./service.nix {inherit lib;};
  cfg = config.services.soloist;
in {
  options.services.soloist = shared.mkOptions {inherit pkgs;};

  config = lib.mkIf cfg.enable {
    assertions = shared.mkAssertions cfg;

    # `soloist ctl` is the same binary, so putting the package on PATH is what
    # makes the control commands usable from a shell.
    home.packages = [cfg.package];

    systemd.user.services.soloist = {
      Unit = {
        Description = "Spotify Soloist headless player";
        # gpg-agent.socket is listed for apiKeyCommand setups that pull the key
        # out of pass; ordering against a unit that does not exist is a no-op.
        After = ["network.target" "pulseaudio.service" "pipewire.service" "gpg-agent.socket"];
      };

      Service = {
        ExecStart = shared.mkStartScript {inherit pkgs cfg;};
        LoadCredential = shared.mkCredentials cfg;
        StateDirectory = "soloist";
        CacheDirectory = "soloist";
        Restart = "on-failure";
        RestartSec = 5;
        # Exit 10 means the build is past its 90-day expiry; a restart loop
        # would only hide that.
        RestartPreventExitStatus = [10];
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
