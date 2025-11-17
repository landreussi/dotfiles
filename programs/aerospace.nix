{
  enable = true;
  userSettings = {
    enable-normalization-flatten-containers = true;
    enable-normalization-opposite-orientation-for-nested-containers = true;
    start-at-login = true;

    gaps = {
      inner = {
        horizontal = 0;
        vertical = 0;
      };
      outer = {
        left = 8;
        right = 8;
        top = 8;
        bottom = 8;
      };
    };

    key-mapping = {
      preset = "qwerty";
    };

    mode.main.binding = {
      # Launch terminal
      cmd-return = "exec open -na kitty";

      # Kill window
      cmd-q = "close";

      # Launcher (replace with your favorite)
      cmd-d = "exec open -na 'Spotlight'";

      # Focus (vim-style)
      cmd-h = "focus left";
      cmd-j = "focus down";
      cmd-k = "focus up";
      cmd-l = "focus right";

      # Focus with arrows
      cmd-left = "focus left";
      cmd-down = "focus down";
      cmd-up = "focus up";
      cmd-right = "focus right";

      # Move windows
      cmd-shift-h = "move left";
      cmd-shift-j = "move down";
      cmd-shift-k = "move up";
      cmd-shift-l = "move right";

      cmd-shift-left = "move left";
      cmd-shift-down = "move down";
      cmd-shift-up = "move up";
      cmd-shift-right = "move right";

      # Splitting
      cmd-ctrl-h = "split horizontal";
      cmd-ctrl-v = "split vertical";

      # Fullscreen
      cmd-f = "layout fullscreen";

      # Layout toggles
      cmd-s = "layout stacking";
      cmd-w = "layout tabbed";
      cmd-e = "layout toggle";

      # Move workspace to next monitor
      cmd-p = "move-workspace-to-monitor right";

      # Floating
      cmd-shift-space = "layout floating";
      cmd-space = "focus toggle-float";

      # Focus parent
      cmd-a = "focus parent";

      # Workspaces
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

      # Reload / Restart
      cmd-shift-c = "reload";
      cmd-shift-r = "restart";

      # Resize
      cmd-ctrl-left = "resize smart -50";
      cmd-ctrl-down = "resize smart -50";
      cmd-ctrl-up = "resize smart +50";
      cmd-ctrl-right = "resize smart +50";
    };

    exec = {
      inherit-env-vars = true;
      after-startup-command = [
        # Example: open a terminal on startup
        # "exec-and-forget open -na kitty"
      ];
    };
  };
}
