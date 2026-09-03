{pkgs, ...}: let
  win = "Mod4";
  alt = "Mod1";
  mod = "${win}+${alt}";

  i3lock = "${pkgs.i3lock}/bin/i3lock -c 000000";
  kitty = "${pkgs.kitty}/bin/kitty";
  dmenu = "${pkgs.dmenu}/bin/dmenu_run -nf '#BBBBBB' -nb '#0B1216' -sb '#294453' -sf '#EEEEEE' -fn 'JetBrainsMono Nerd Font Propo-10' -p 'dmenu'";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  spotify = "${pkgs.spotify-player}/bin/spotify_player";

  # The twenty workspace bindings are mechanical, so generate them instead of
  # writing them out one by one.
  workspaces = builtins.genList (i: i + 1) 10;
  # Workspace 10 sits on the `0` key.
  wsKey = n:
    if n == 10
    then "0"
    else toString n;
  wsBindings = prefix: action:
    builtins.listToAttrs (map (n: {
        name = "${win}+${prefix}${wsKey n}";
        value = "${action} ${toString n}";
      })
      workspaces);
in {
  enable = true;

  config = {
    modifier = win;
    terminal = kitty;
    menu = dmenu;

    floating = {
      modifier = win;
      titlebar = false;
      border = 1;
    };

    # Titlebars off, 1px borders.
    window = {
      titlebar = false;
      border = 1;
    };

    colors = {
      background = "#FFFFFF";
      focused = {
        border = "#44564F";
        background = "#44564F";
        text = "#FFFFFF";
        indicator = "#5E776E";
        childBorder = "#44564F";
      };
      focusedInactive = {
        border = "#000000";
        background = "#5F676A";
        text = "#FFFFFF";
        indicator = "#484E50";
        childBorder = "#5F676A";
      };
      unfocused = {
        border = "#333333";
        background = "#222222";
        text = "#888888";
        indicator = "#292D2E";
        childBorder = "#222222";
      };
      urgent = {
        border = "#2F343A";
        background = "#900000";
        text = "#FFFFFF";
        indicator = "#900000";
        childBorder = "#900000";
      };
      placeholder = {
        border = "#000000";
        background = "#0C0C0C";
        text = "#FFFFFF";
        indicator = "#000000";
        childBorder = "#0C0C0C";
      };
    };

    # Resize is bound directly on $mod+arrows, so the default resize mode is
    # dropped rather than left with no key to enter it.
    modes = {};

    # HDMI-1 is the primary ultrawide, so it takes workspace 1; HDMI-0 sits
    # above it with workspace 2. The rest follow the focused output.
    workspaceOutputAssign = [
      {
        workspace = "1";
        output = "HDMI-1";
      }
      {
        workspace = "2";
        output = "HDMI-0";
      }
    ];

    keybindings =
      (wsBindings "" "workspace number")
      // (wsBindings "Shift+" "move container to workspace number")
      // {
        "${win}+Return" = "exec ${kitty}";
        "${win}+q" = "kill";
        "${win}+d" = "exec ${dmenu}";

        # Screenshot a region, then park it in ~/imgs.
        "${win}+Shift+s" = "exec ${pkgs.scrot}/bin/scrot -s '%Y-%m-%d_$wx$h_scrot.png' -e 'mv $f ~/imgs/'";

        "${win}+h" = "focus left";
        "${win}+j" = "focus down";
        "${win}+k" = "focus up";
        "${win}+l" = "focus right";

        "${win}+Left" = "focus left";
        "${win}+Down" = "focus down";
        "${win}+Up" = "focus up";
        "${win}+Right" = "focus right";

        "${win}+Shift+Left" = "move left";
        "${win}+Shift+Down" = "move down";
        "${win}+Shift+Up" = "move up";
        "${win}+Shift+Right" = "move right";

        "${win}+Ctrl+h" = "split h";
        "${win}+Ctrl+v" = "split v";

        "${win}+f" = "fullscreen toggle";

        "${win}+s" = "layout stacking";
        "${win}+w" = "layout tabbed";
        "${win}+e" = "layout toggle split";

        "${mod}+space" = "floating toggle";
        "${win}+space" = "focus mode_toggle";
        "${win}+a" = "focus parent";

        "${mod}+l" = "exec ${i3lock}";

        "${mod}+c" = "reload";
        "${mod}+r" = "restart";
        "${mod}+e" = "exec ${pkgs.i3}/bin/i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' '${pkgs.i3}/bin/i3-msg exit'";

        # Resize, without a binding mode.
        "${mod}+Left" = "resize grow width 5 px or 5 ppt";
        "${mod}+Down" = "resize shrink height 5 px or 5 ppt";
        "${mod}+Up" = "resize grow height 5 px or 5 ppt";
        "${mod}+Right" = "resize shrink width 5 px or 5 ppt";

        # Media.
        "${mod}+h" = "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
        "${mod}+j" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        "${mod}+k" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
        "${mod}+o" = "exec ${spotify} playback previous";
        "${mod}+p" = "exec ${spotify} playback play-pause";
        "${mod}+bracketleft" = "exec ${spotify} playback next";

        # Power.
        "${mod}+z" = "exec systemctl suspend";
        "${mod}+a" = "exec reboot";
        "${mod}+q" = "exec shutdown 0";
      };

    startup = [
      # Grabs a logind suspend inhibit lock and locks the screen before suspend.
      {
        command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- ${i3lock} --nofork";
        notification = false;
      }
      {
        command = "${pkgs.feh}/bin/feh --bg-scale $HOME/.background-image";
        always = true;
        notification = false;
      }
      # startx never reaches graphical-session.target, so dunst's user unit has
      # to be kicked by hand.
      {
        command = "systemctl --user start dunst";
        notification = false;
      }
    ];

    bars = [
      {
        position = "bottom";
        trayOutput = "HDMI-0";
        fonts = {
          names = ["JetBrainsMono Nerd Font Propo"];
          size = 9.0;
        };
        # home-manager writes the bar config to config-<bar name>.toml.
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-default.toml";
        # There is no home-manager option for the bar's `output`.
        extraConfig = "output HDMI-0";
        colors = {
          background = "#32302F";
          statusline = "#ebdbb2";
          separator = "#665c54";
          focusedWorkspace = {
            border = "#458588";
            background = "#458588";
            text = "#282828";
          };
          activeWorkspace = {
            border = "#3c3836";
            background = "#504945";
            text = "#ebdbb2";
          };
          inactiveWorkspace = {
            border = "#3c3836";
            background = "#32302F";
            text = "#a89984";
          };
          urgentWorkspace = {
            border = "#cc241d";
            background = "#cc241d";
            text = "#fbf1c7";
          };
          bindingMode = {
            border = "#d79921";
            background = "#d79921";
            text = "#282828";
          };
        };
      }
    ];
  };
}
