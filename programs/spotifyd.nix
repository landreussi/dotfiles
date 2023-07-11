super@{ pkgs, ... }:

{
  enable = true;
  settings = {
    global = {
      username = "landreussi";
      password_cmd = "pass spotify";
      initial_volume = "100";
      volume_normalisation = true;
      bitrate = 320;
      device_type = "a_v_r";
      device_name = "stout";
    };
  };
}
