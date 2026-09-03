{
  enable = true;
  extraConfig = ''
    set -g mouse on

    unbind C-b
    set -g prefix C-Space
    bind C-Space send-prefix

    # Vim style pane selection
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R

    # Start windows and panes at 1, not 0
    set -g base-index 1
    set -g pane-base-index 1
    set-window-option -g pane-base-index 1
    set-option -g renumber-windows on

    # Use Alt-arrow keys without prefix key to switch panes
    bind -n M-Left select-pane -L
    bind -n M-Right select-pane -R
    bind -n M-Up select-pane -U
    bind -n M-Down select-pane -D

    # Shift arrow to switch windows
    bind -n S-Left  previous-window
    bind -n S-Right next-window

    # Shift Alt vim keys to switch windows
    bind -n M-H previous-window
    bind -n M-L next-window

    # Mirrors the keybinds from programs/zellij.nix (which themselves mirror
    # programs/kitty.nix). All prefix-free (`bind -n`), the way zellij's
    # `shared_except "locked"` bindings fire from any mode.
    #
    # `C-S-<key>` is only distinguishable from `C-<key>` under the kitty
    # keyboard protocol, so the extended-keys handshake below is required.
    # Alacritty and kitty both negotiate it; under a terminal that does not,
    # only the `M-` bindings register.
    set -s extended-keys on
    set -as terminal-features 'xterm*:extkeys'
    set -as terminal-features 'alacritty*:extkeys'

    # Focus the neighbouring pane -- kitty's `neighboring_window`.
    bind -n C-M-h select-pane -L
    bind -n C-M-l select-pane -R
    bind -n C-M-j select-pane -D
    bind -n C-M-k select-pane -U

    # Drag the focused pane around -- kitty's `move_window`. tmux has no
    # directional move, so swap with whatever pane sits that way.
    bind -n C-S-h swap-pane -s '{left-of}'
    bind -n C-S-l swap-pane -s '{right-of}'
    bind -n C-S-j swap-pane -s '{down-of}'
    bind -n C-S-k swap-pane -s '{up-of}'

    # Cycle arrangements -- kitty's `next_layout`, zellij's `NextSwapLayout`.
    bind -n C-S-z next-layout

    # Zoom the focused pane -- zellij's `ToggleFocusFullscreen`.
    bind -n C-S-o resize-pane -Z

    # Open a terminal aside, inheriting the cwd -- kitty's `launch --cwd=current`.
    bind -n C-S-Enter split-window -h -c "#{pane_current_path}"
    bind -n C-S-d split-window -v -c "#{pane_current_path}"
    bind -n C-S-w kill-pane

    # Floating scratch pane -- zellij's `ToggleFloatingPanes`. tmux popups do
    # not toggle, so this opens one; exit the shell inside it to dismiss.
    bind -n C-S-f display-popup -E -d "#{pane_current_path}"

    # Tabs (tmux windows).
    bind -n C-S-t new-window -c "#{pane_current_path}"
    bind -n C-S-Right next-window
    bind -n C-S-Left previous-window
    bind -n C-S-1 select-window -t 1
    bind -n C-S-2 select-window -t 2
    bind -n C-S-3 select-window -t 3
    bind -n C-S-4 select-window -t 4
    bind -n C-S-5 select-window -t 5
    bind -n C-S-6 select-window -t 6
    bind -n C-S-7 select-window -t 7
    bind -n C-S-8 select-window -t 8
    bind -n M-1 select-window -t 1
    bind -n M-2 select-window -t 2
    bind -n M-3 select-window -t 3
    bind -n M-4 select-window -t 4
    bind -n M-5 select-window -t 5
    bind -n M-6 select-window -t 6
    bind -n M-7 select-window -t 7
    bind -n M-8 select-window -t 8


    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    set -g @plugin 'christoomey/vim-tmux-navigator'
    set -g @plugin 'tmux-plugins/tmux-yank'

    run '~/.tmux/plugins/tpm/tpm'

    # Gruvbox Material Dark Medium. Same values kitty picks up from
    # ~/.config/kitty/current-theme.conf, so tmux tabs match kitty tabs.
    # Swapping theme means editing only these six lines.
    set -g @bar_bg "#282828"
    set -g @tab_bg "#202020"
    set -g @tab_fg "#d4be98"
    set -g @tab_active_bg "#d4be98"
    set -g @tab_active_fg "#444444"
    set -g @tab_sep_fg "#44564f"

    # Status bar: kitty's slanted powerline tab bar, nothing else. Colours all
    # come from the @-options above. Set after `run tpm` so no plugin
    # overwrites it.
    # Slants are U+E0BC (solid) and U+E0BD (thin) -- a Nerd Font is required.
    # Thin one is used between two inactive tabs, solid where the tab colour
    # changes (first, last, and either side of the active tab).
    set -g status on
    set -g status-position bottom
    set -g status-justify left
    set -g status-interval 60
    set -g status-left ""
    set -g status-right ""
    set -g status-left-length 0
    set -g status-right-length 0

    # Window name mirrors kitty's tab_title_template: index, running command,
    # basename of the cwd.
    setw -g automatic-rename on
    setw -g window-status-separator ""
    setw -g window-status-format '#{?window_start_flag,#[fg=#{@bar_bg}#,bg=#{@tab_bg}],}#[fg=#{@tab_fg}#,bg=#{@tab_bg}] #I #W #{b:pane_current_path} #{?#{==:#{e|+:#{window_index},1},#{active_window_index}},#[fg=#{@tab_bg}#,bg=#{@tab_active_bg}],#{?window_end_flag,#[fg=#{@tab_bg}#,bg=#{@bar_bg}],#[fg=#{@tab_sep_fg}#,bg=#{@tab_bg}]}}'
    setw -g window-status-current-format '#{?window_start_flag,#[fg=#{@bar_bg}#,bg=#{@tab_active_bg}],}#[fg=#{@tab_active_fg}#,bg=#{@tab_active_bg}#,italics] #I #W #{b:pane_current_path} #[noitalics]#{?window_end_flag,#[fg=#{@tab_active_bg}#,bg=#{@bar_bg}],#[fg=#{@tab_active_bg}#,bg=#{@tab_bg}]}'

    # Everything else that carries colour, same palette.
    set -g status-style "bg=#{@bar_bg},fg=#{@tab_fg}"
    set -g message-style "bg=#{@tab_bg},fg=#{@tab_fg}"
    set -g message-command-style "bg=#{@tab_bg},fg=#{@tab_fg}"
    set -g mode-style "bg=#{@tab_active_bg},fg=#{@tab_active_fg}"
    set -g pane-border-style "fg=#{@tab_sep_fg}"
    set -g pane-active-border-style "fg=#{@tab_active_bg}"
    set -g display-panes-colour "#44564f"
    set -g display-panes-active-colour "#d4be98"

    # set vi-mode
    set-window-option -g mode-keys vi
    # keybindings
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"
  '';
}
