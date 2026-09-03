# Same modules and order as the old programs/i3status/config, now on
# i3status-rust so the GPU load can come from its `nvidia_gpu` block. The
# `battery 0` module stays dropped because stout has no battery.
#
# Numbers use the `eng` formatter, whose `w` is a *significant digit* count,
# not a decimal count: `w:4` renders 5.90 and 16.6, `w:5` renders 16.63. The
# widths below are picked per placeholder so the values this host actually
# reports land on two decimals; a value an order of magnitude larger loses one.
{
  enable = true;

  bars.default = {
    # Nerd Font glyphs, to match the bar's "JetBrainsMono Nerd Font Propo".
    icons = "material-nf";

    blocks = [
      {
        block = "net";
        device = "enp5s0";
        interval = 5;
        # There is no link-speed placeholder to stand in for i3status's
        # `%speed`, so this shows actual throughput instead.
        format = " $icon $ip ^icon_net_down $speed_down.eng(w:4,p:K) ^icon_net_up $speed_up.eng(w:4,p:K) ";
        inactive_format = " $icon down ";
        missing_format = " $icon down ";
      }
      {
        block = "cpu";
        interval = 5;
        format = " $icon $utilization.eng(w:4) ";
        # The old config had a single `max_threshold = 80`, so every state
        # flips at the same point instead of shading through info/warning.
        info_cpu = 80.0;
        warning_cpu = 80.0;
        critical_cpu = 80.0;
      }
      {
        block = "nvidia_gpu";
        interval = 5;
        format = " $icon $utilization.eng(w:4) ";
        # This block colors itself by temperature; the thresholds are pushed
        # out of reach to keep it as flat as the rest of the bar. Lower them
        # (idle 50 / good 70 / info 75 / warning 80) to get that coloring back.
        idle = 200;
        good = 200;
        info = 200;
        warning = 200;
      }
      {
        block = "disk_space";
        path = "/";
        info_type = "available";
        interval = 5;
        # `p:G` pins the prefix to GB so the block does not jump to TB/MB.
        format = " $icon $available.eng(w:6,p:G) left ";
        # The defaults are percentages (warn under 20% free), which on a 909G
        # root sits above the normal fill level and keeps the block yellow.
        # The old config had no threshold at all, so use absolute sizes.
        alert_unit = "GB";
        warning = 20.0;
        alert = 10.0;
      }
      {
        block = "memory";
        interval = 5;
        # Used is single-digit GiB and total is double-digit, hence the
        # different widths for the same two decimals.
        format = " $icon $mem_used.eng(w:4,p:Gi) / $mem_total.eng(w:5,p:Gi) ";
        # i3status thresholded on memory left (10%/5%), i3status-rust on
        # memory used, so the numbers are inverted.
        warning_mem = 90.0;
        critical_mem = 95.0;
      }
      {
        block = "time";
        interval = 5;
        format = " $icon $timestamp.datetime(f:'%d/%m/%Y %H:%M') ";
      }
    ];

    # The module builds its own `theme` table out of the `theme` option, and
    # `settings` is merged over it, so the name has to be repeated here.
    settings.theme = {
      theme = "plain";
      # color_good / color_degraded / color_bad from the old general block,
      # over the i3 bar's own background and statusline colors.
      overrides = {
        idle_bg = "#32302F";
        idle_fg = "#ebdbb2";
        info_bg = "#32302F";
        info_fg = "#ebdbb2";
        good_bg = "#32302F";
        good_fg = "#BEDA93";
        warning_bg = "#32302F";
        warning_fg = "#F4D582";
        critical_bg = "#32302F";
        critical_fg = "#EC7777";
        # Empty separator: i3status-rust already emits `separator: false` for
        # its own blocks, so the bar ends up with no divider at all.
        separator = "";
        separator_bg = "#32302F";
        separator_fg = "#32302F";
      };
    };
  };
}
