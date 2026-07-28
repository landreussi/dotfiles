{
  enable = true;
  settings = {
    global = {
      # Pin notifications to the secondary display instead of the X primary
      # output (HDMI-1). "follow = none" keeps them there regardless of where
      # the mouse or the focused window is.
      monitor = "HDMI-0";
      follow = "none";

      origin = "top-left";
      # Vertical offset clears the i3bar, which also lives on HDMI-0.
      offset = "(10, 35)";
      width = "(200, 450)";
      height = "(0, 300)";
      notification_limit = 7;

      frame_width = 1;
      frame_color = "#458588";
      separator_color = "frame";
      corner_radius = 4;
      gap_size = 5;

      font = "JetBrainsMono Nerd Font Propo 9";
      markup = "full";
      format = "<b>%s</b>\\n%b";
      word_wrap = true;

      mouse_left_click = "close_current";
      mouse_middle_click = "close_all";
      mouse_right_click = "do_action, close_current";
    };

    urgency_low = {
      background = "#32302F";
      foreground = "#a89984";
      timeout = 3;
    };

    urgency_normal = {
      background = "#32302F";
      foreground = "#ebdbb2";
      timeout = 6;
    };

    urgency_critical = {
      background = "#cc241d";
      foreground = "#fbf1c7";
      frame_color = "#fbf1c7";
      timeout = 10;
    };
  };
}
