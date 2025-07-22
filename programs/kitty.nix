super@{ pkgs, ... }: {
  enable = true;
  settings = let
    family = "JetBrainsMono Nerd Font";
    fontWithStyle = style: family + " " + style;
  in {
    font_family = family;
    bold_font = fontWithStyle "Bold";
    italic_font = fontWithStyle "Italic";
    bold_italic_font = fontWithStyle "Bold Italic";
    font_size = 17;

    scrollback_lines = 1000;
    mouse_hide_wait = -1;
    url_style = "straight";
    enabled_layouts = "horizontal";

    tab_bar_margin_width = 0;
    tab_bar_style = "powerline";
    tab_powerline_style = "slanted";
    tab_bar_align = "center";
    tab_title_template =
      "{index} {tab.active_exe.replace('-', '')} {tab.active_wd.split('/')[-1]}";
  };
  # fuck tmux hehe
  extraConfig = ''
    include current-theme.conf
    map ctrl+alt+left neighboring_window left
    map ctrl+alt+right neighboring_window right
    map ctrl+shift+j previous_tab
    map ctrl+shift+k next_tab
    map ctrl+shift+1 goto_tab 1
    map ctrl+shift+2 goto_tab 2
    map ctrl+shift+3 goto_tab 3
    map ctrl+shift+4 goto_tab 4
    map ctrl+shift+5 goto_tab 5
    map ctrl+shift+6 goto_tab 6
    map ctrl+shift+7 goto_tab 7
    map ctrl+shift+8 goto_tab 8
    map ctrl+shift+9 goto_tab 9
  '';
}
