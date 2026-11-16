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
    confirm_os_windows_close = false;
    paste_actions = "quote-urls-at-prompt,replace-dangerous-control-codes";
  };
  extraConfig = ''
    include current-theme.conf

    map alt+h neighboring_window left
    map alt+l neighboring_window right
    map alt+j neighboring_window bottom
    map alt+k neighboring_window top

    map alt+shift+k move_window up
    map alt+shift+h move_window left
    map alt+shift+l move_window right
    map alt+shift+j move_window down
    map alt+z       next_layout
    map alt+q       close_window

    map alt+shift+, move_tab_backward
    map alt+shift+. move_tab_forward
    map alt+t       new_tab
    map alt+,       previous_tab
    map alt+.       next_tab
    map alt+1       goto_tab 1
    map alt+2       goto_tab 2
    map alt+3       goto_tab 3
    map alt+4       goto_tab 4
    map alt+5       goto_tab 5
    map alt+6       goto_tab 6
    map alt+7       goto_tab 7
    map alt+8       goto_tab 8

    map --when-focus-on title:terminal alt+; combine : neighboring_window left : toggle_layout stack
    map --when-focus-on num:0          alt+; combine : toggle_layout stack : nth_window -1
    map                                alt+enter launch --title=terminal --cwd=current --copy-env --bias=-20
    # A separate kitty instance; i3 matches the class and sends it to the portrait
    # screen. launch has no layout flag, so the instance overrides enabled_layouts
    # to start stacked vertically (stack stays so alt+; still toggles).
    map                                alt+shift+enter launch --type=background --cwd=current --copy-env kitty --class=kitty-detached -o enabled_layouts=vertical,stack

  '';
}
