super@{ pkgs, ... }:

{
  enable = true;
  settings = {
    global = {
      initial_volume = "100";
      volume_normalisation = true;
      bitrate = 320;
      device_type = "s_t_b";
      device_name = "stout";
    };
  };
}
