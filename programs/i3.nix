{pkgs, ...}: let
  win = "Mod4";
  alt = "Mod1";

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

  # Shared by the bar on each screen.
  bar = {
    position = "top";
    fonts = {
      names = ["JetBrainsMono Nerd Font Propo"];
      size = 11.0;
    };
    # home-manager writes the bar config to config-<bar name>.toml.
    statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-default.toml";
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
  };
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
      # kitty's alt+shift+enter opens an OS window with this class. Send it to
      # the portrait screen and follow it there.
      commands = [
        {
          criteria = {class = "^kitty-detached$";};
          command = "move container to output HDMI-1, focus";
        }
      ];
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

    # HDMI-0 is the primary ultrawide, so it takes workspace 1; HDMI-1 sits
    # to its right in portrait with workspace 2. The rest follow the focused
    # output.
    workspaceOutputAssign = [
      {
        workspace = "1";
        output = "HDMI-0";
      }
      {
        workspace = "2";
        output = "HDMI-1";
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
        "${win}+Shift+s" = "exec ${pkgs.scrot}/bin/scrot -s '%Y-%m-%d_$wxh_scrot.png' -e 'mv $f ~/imgs/'";

        "${win}+h" = "focus left";
        "${win}+j" = "focus down";
        "${win}+k" = "focus up";
        "${win}+l" = "focus right";

        "${win}+Left" = "focus left";
        "${win}+Down" = "focus down";
        "${win}+Up" = "focus up";
        "${win}+Right" = "focus right";

        "${win}+Shift+h" = "move left";
        "${win}+Shift+j" = "move down";
        "${win}+Shift+k" = "move up";
        "${win}+Shift+l" = "move right";

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

        "${win}+${alt}+space" = "floating toggle";
        "${win}+space" = "focus mode_toggle";
        "${win}+a" = "focus parent";

        "Ctrl+${win}+${alt}+l" = "exec ${i3lock}";

        "${win}+${alt}+c" = "reload";
        "${win}+${alt}+r" = "restart";
        "${win}+${alt}+e" = "exec ${pkgs.i3}/bin/i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' '${pkgs.i3}/bin/i3-msg exit'";

        # Resize, without a binding mode.
        "${win}+Shift+z+Left" = "resize grow width 5 px or 5 ppt";
        "${win}+Shift+z+Down" = "resize shrink height 5 px or 5 ppt";
        "${win}+Shift+z+Up" = "resize grow height 5 px or 5 ppt";
        "${win}+Shift+z+Right" = "resize shrink width 5 px or 5 ppt";

        "${win}+Shift+z+h" = "resize grow width 5 px or 5 ppt";
        "${win}+Shift+z+j" = "resize shrink height 5 px or 5 ppt";
        "${win}+Shift+z+k" = "resize grow height 5 px or 5 ppt";
        "${win}+Shift+z+l" = "resize shrink width 5 px or 5 ppt";

        # Media.
        "${win}+${alt}+m" = "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
        "${win}+${alt}+j" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        "${win}+${alt}+k" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
        "${win}+${alt}+h" = "exec ${spotify} playback previous";
        "${win}+${alt}+l" = "exec ${spotify} playback next";
        "${win}+${alt}+p" = "exec ${spotify} playback play-pause";

        # Power.
        "${win}+${alt}+a" = "exec reboot";
        "${win}+${alt}+q" = "exec shutdown 0";
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

    # One bar per screen: the portrait HDMI-1 keeps its workspace buttons but
    # drops the status line, which lives on the ultrawide with the tray.
    bars = [
      (bar
        // {
          trayOutput = "primary";
          extraConfig = "output HDMI-0";
        })
      (bar
        // {
          statusCommand = null;
          trayOutput = "none";
          extraConfig = "output HDMI-1";
        })
    ];
  };
}
