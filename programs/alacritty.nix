super@{ pkgs, ... }: {
  enable = true;
  settings = {
    draw_bold_text_with_bright_colors = true;

    font = let
      family = "JetBrainsMono Nerd Font";
      fontWithStyle = style: { inherit family style; };
    in {
      medium = fontWithStyle "Medium";
      bold = fontWithStyle "Bold";
      italic = fontWithStyle "Italic";
      bold_italic = fontWithStyle "Bold Italic";

      size = 17;
    };

    live_config_reload = true;
    mouse.hide_when_typing = false;
    selection.save_to_clipboard = true;

    window = {
      decorations = "full";
      startup_mode = "Fullscreen";
    };

    # https://github.com/aarowill/base16-alacritty/blob/master/colors/base16-gruvbox-material-dark-soft.yml
    colors = {
      primary = {
        background = "0x32302f";
        foreground = "0xddc7a1";
      };

      cursor = {
        text = "0x32302f";
        cursor = "0xddc7a1";
      };

      normal = {
        black = "0x32302f";
        red = "0xea6962";
        green = "0xa9b665";
        yellow = "0xd8a657";
        blue = "0x7daea3";
        magenta = "0xd3869b";
        cyan = "0x89b482";
        white = "0xddc7a1";
      };

      bright = {
        black = "0x7c6f64";
        red = "0xe78a4e";
        green = "0x3c3836";
        yellow = "0x5a524c";
        blue = "0xbdae93";
        magenta = "0xebdbb2";
        cyan = "0xbd6f3e";
        white = "0xfbf1c7";
      };
    };
  };
}
