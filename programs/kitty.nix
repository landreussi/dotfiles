{
  enable = true;
  shellIntegration.enableFishIntegration = true;
  enableGitIntegration = true;
  darwinLaunchOptions = ["--override font_size=17"];
  settings = let
    family = "JetBrainsMono Nerd Font Mono";
    fontWithStyle = style: family + " " + style;
  in {
    font_family = family;
    bold_font = fontWithStyle "Bold";
    italic_font = fontWithStyle "Italic";
    bold_italic_font = fontWithStyle "Bold Italic";
    font_size = 12;

    mouse_hide_wait = -1;
    url_style = "straight";

    tab_bar_margin_width = 0;
    tab_bar_style = "powerline";
    tab_powerline_style = "slanted";
    tab_bar_align = "center";
    tab_title_template = "{index} {tab.active_oldest_exe.replace('-', '')} {tab.active_wd.split('/')[-1]}";
    enabled_layouts = "tall,stack,splits:split_axis=horizontal";
    sync_to_monitor = true;
    bell_on_tab = "🔔 ";
    window_border_width = "0pt";
    allow_remote_control = true;
    dynamic_background_opacity = true;
  };
  extraConfig = ''
    include current-theme.conf
    map ctrl+alt+h neighboring_window left
    map ctrl+alt+l neighboring_window right
    map ctrl+alt+j neighboring_window bottom
    map ctrl+alt+k neighboring_window top

    map ctrl+shift+k move_window up
    map ctrl+shift+h move_window left
    map ctrl+shift+l move_window right
    map ctrl+shift+j move_window down

    map ctrl+shift+z next_layout
    map --when-focus-on num:0 ctrl+shift+; combine : toggle_layout stack : nth_window -1
    map --when-focus-on title:terminal ctrl+shift+; combine : neighboring_window left : toggle_layout stack
    map ctrl+shift+enter launch --title=terminal --cwd=current --copy-env --bias=-20
    map ctrl+shift+1 goto_tab 1
    map ctrl+shift+2 goto_tab 2
    map ctrl+shift+3 goto_tab 3
    map ctrl+shift+4 goto_tab 4
    map ctrl+shift+5 goto_tab 5
    map ctrl+shift+6 goto_tab 6
    map ctrl+shift+7 goto_tab 7
    map ctrl+shift+8 goto_tab 8
  '';
}
