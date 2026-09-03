{
  enable = true;
  settings = {
    global = {
      # Pin notifications to the secondary display instead of the X primary
      # output (HDMI-1). "follow = none" keeps them there regardless of where
      # the mouse or the focused window is.
      monitor = "HDMI-0";
      follow = "none";

      origin = "top-right";
      # Vertical offset clears the i3bar, which also lives on HDMI-0.
      offset = "(10, 10)";
      width = "(200, 450)";
      height = "(0, 300)";
      notification_limit = 7;

      frame_width = 2;
      separator_color = "frame";
      corner_radius = 4;
      gap_size = 5;

      font = "JetBrainsMono Nerd Font Propo 9";
      markup = "full";
      format = "<b>%s</b>\\n%b";
      word_wrap = true;

      mouse_left_click = "do_action, close_current";
      mouse_middle_click = "close_all";
      mouse_right_click = "close_current";
    };

    urgency_low = {
      background = "#32302F";
      foreground = "#81f1f7";
      frame_color = "#81f1f7";
      timeout = 3;
    };

    urgency_normal = {
      background = "#32302F";
      foreground = "#f7d95e";
      frame_color = "#f7d95e";
      timeout = 6;
    };

    urgency_critical = {
      background = "#32302F";
      foreground = "#f7665e";
      frame_color = "#f7665e";
      timeout = 10;
    };
  };
}
