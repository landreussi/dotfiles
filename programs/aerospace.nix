{
  lib,
  pkgs,
  ...
}: {
  enable = true;
  userSettings = {
    enable-normalization-flatten-containers = false;
    enable-normalization-opposite-orientation-for-nested-containers = false;
    default-root-container-layout = "tiles";
    start-at-login = true;

    gaps = {
      inner = {
        horizontal = 0;
        vertical = 0;
      };
      outer = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };
    };

    key-mapping = {
      preset = "qwerty";
    };

    mode.main.binding = {
      cmd-q = "close";
      cmd-enter = "exec-and-forget ${lib.getExe pkgs.kitty}";
      cmd-shift-s = "exec-and-forget screencapture -i -c";

      cmd-h = "focus left";
      cmd-j = "focus down";
      cmd-k = "focus up";
      cmd-l = "focus right";

      cmd-left = "focus-monitor left";
      cmd-right = "focus-monitor right";

      cmd-shift-h = "move left";
      cmd-shift-j = "move down";
      cmd-shift-k = "move up";
      cmd-shift-l = "move right";

      cmd-shift-r = "reload-config";

      cmd-ctrl-h = "split horizontal";
      cmd-ctrl-v = "split vertical";

      cmd-alt-h = "volume mute-toggle";
      cmd-alt-k = "volume up";
      cmd-alt-j = "volume down";
      cmd-alt-o = "exec-and-forget ${lib.getExe pkgs.spotify-player} playback previous";
      cmd-alt-p = "exec-and-forget ${lib.getExe pkgs.spotify-player} playback play-pause";
      cmd-alt-leftSquareBracket = "exec-and-forget ${lib.getExe pkgs.spotify-player} playback next";

      cmd-f = "layout floating";
      cmd-w = "layout accordion";
      cmd-e = "layout tiling";

      cmd-shift-right = "move-node-to-monitor right";
      cmd-shift-left = "move-node-to-monitor left";

      cmd-1 = "workspace 1";
      cmd-2 = "workspace 2";
      cmd-3 = "workspace 3";
      cmd-4 = "workspace 4";
      cmd-5 = "workspace 5";
      cmd-6 = "workspace 6";
      cmd-7 = "workspace 7";
      cmd-8 = "workspace 8";
      cmd-9 = "workspace 9";
      cmd-0 = "workspace 10";

      cmd-shift-1 = "move-node-to-workspace 1";
      cmd-shift-2 = "move-node-to-workspace 2";
      cmd-shift-3 = "move-node-to-workspace 3";
      cmd-shift-4 = "move-node-to-workspace 4";
      cmd-shift-5 = "move-node-to-workspace 5";
      cmd-shift-6 = "move-node-to-workspace 6";
      cmd-shift-7 = "move-node-to-workspace 7";
      cmd-shift-8 = "move-node-to-workspace 8";
      cmd-shift-9 = "move-node-to-workspace 9";
      cmd-shift-0 = "move-node-to-workspace 10";

      cmd-ctrl-left = "resize smart -50";
      cmd-ctrl-down = "resize smart -50";
      cmd-ctrl-up = "resize smart +50";
      cmd-ctrl-right = "resize smart +50";
    };

    exec.inherit-env-vars = true;
  };
}
