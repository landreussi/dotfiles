{
  enable = false;
  enableFishIntegration = true;
  attachExistingSession = true;
  exitShellOnExit = true;

  settings = {
    theme = "gruvbox-material";

    # Panes are laid out by zellij's swap layouts, so `NextSwapLayout` behaves
    # like kitty's `next_layout` instead of cycling a single static arrangement.
    auto_layout = true;
    pane_frames = true;
    pane_frame_style = "titles";

    default_layout = "default";
    copy_on_select = true;
    mouse_mode = true;
    scroll_buffer_size = 10000;
    session_serialization = true;

    # Same palette as programs/alacritty.nix, so both terminals match.
    # https://github.com/aarowill/base16-alacritty/blob/master/colors/base16-gruvbox-material-dark-soft.yml
    themes."gruvbox-material" = {
      fg = "#ddc7a1";
      bg = "#32302f";
      black = "#32302f";
      red = "#ea6962";
      green = "#a9b665";
      yellow = "#d8a657";
      blue = "#7daea3";
      magenta = "#d3869b";
      cyan = "#89b482";
      white = "#ddc7a1";
      orange = "#e78a4e";
    };
  };

  # Mirrors the window/tab bindings from programs/kitty.nix. They live in
  # `shared_except "locked"` so they fire from any mode, the way kitty's global
  # `map` entries do, while zellij's own modal defaults stay intact.
  #
  # `Ctrl Shift <key>` needs the kitty keyboard protocol to be told apart from
  # plain `Ctrl <key>`; alacritty and kitty both negotiate it. Under a terminal
  # that does not, only the `Alt` bindings below will register.
  extraConfig = ''
    keybinds {
        shared_except "locked" {
            // Focus the neighbouring pane -- kitty's `neighboring_window`.
            bind "Ctrl Alt h" { MoveFocus "Left"; }
            bind "Ctrl Alt l" { MoveFocus "Right"; }
            bind "Ctrl Alt j" { MoveFocus "Down"; }
            bind "Ctrl Alt k" { MoveFocus "Up"; }

            // Drag the focused pane around -- kitty's `move_window`.
            bind "Ctrl Shift h" { MovePane "Left"; }
            bind "Ctrl Shift l" { MovePane "Right"; }
            bind "Ctrl Shift j" { MovePane "Down"; }
            bind "Ctrl Shift k" { MovePane "Up"; }

            // Cycle arrangements -- kitty's `next_layout`.
            bind "Ctrl Shift z" { NextSwapLayout; }

            // Zoom the focused pane -- kitty's `toggle_layout stack`.
            bind "Ctrl Shift o" { ToggleFocusFullscreen; }

            // Open a terminal aside, inheriting the cwd -- kitty's
            // `launch --cwd=current`. Zellij passes the cwd down on its own.
            bind "Ctrl Shift Enter" { NewPane "Right"; }
            bind "Ctrl Shift d" { NewPane "Down"; }
            bind "Ctrl Shift w" { CloseFocus; }

            // Floating scratch pane, closest thing to a detached kitty window.
            bind "Ctrl Shift f" { ToggleFloatingPanes; }

            // Tabs.
            bind "Ctrl Shift t" { NewTab; }
            bind "Ctrl Shift 1" "Alt 1" { GoToTab 1; }
            bind "Ctrl Shift 2" "Alt 2" { GoToTab 2; }
            bind "Ctrl Shift 3" "Alt 3" { GoToTab 3; }
            bind "Ctrl Shift 4" "Alt 4" { GoToTab 4; }
            bind "Ctrl Shift 5" "Alt 5" { GoToTab 5; }
            bind "Ctrl Shift 6" "Alt 6" { GoToTab 6; }
            bind "Ctrl Shift 7" "Alt 7" { GoToTab 7; }
            bind "Ctrl Shift 8" "Alt 8" { GoToTab 8; }
        }
    }
  '';
}
