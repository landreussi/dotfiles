super@{ pkgs, ... }:

{
  enable = true;
  settings = {
    username = "landreussi";
    password_cmd = "pass spotify";
    initial_volume = 100;
    volume_normalisation = true;
    bitrate = 320;
  };
}
