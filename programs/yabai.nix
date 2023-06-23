super@{ pkgs, ... }:
{
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout                    = "bsp";
      top_padding               = 2;
      bottom_padding            = 2;
      left_padding              = 2;
      right_padding             = 2;
      window_gap                = 2;
      mouse_follows_focus       = "on";
      focus_follows_mouse       = "off";
      window_topmost            = "off";
      window_opacity            = "off";
      window_shadow             = "off";
      window_border             = "on";
      window_border_width       = 1;
      window_border_radius      = 6;
      active_window_border_color= "0xff775759";
      normal_window_border_color= "0xff555555";
      insert_feedback_color     = "0xffd75f5f";
      active_window_opacity     = "1.0";
      normal_window_opacity     = "0.90";
      split_ratio               = "0.50";
      auto_balance              = "off";
      mouse_modifier            = "fn";
      mouse_action1             = "move";
      mouse_action2             = "resize";
    };
    extraConfig = ''
      # ===== Rules ==================================
      
      yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
      yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      yabai -m rule --add label="System Preferences" app="^System Preferences$" title=".*" manage=off
      yabai -m rule --add label="App Store" app="^App Store$" manage=off
      yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
      yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
      yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
      yabai -m rule --add label="Software Update" title="Software Update" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
    '';
}

