super @ {pkgs, ...}: {
  enable = true;
  viAlias = true;
  vimAlias = true;
  withNodeJs = false;
  withRuby = false;
  withPython3 = false;
  plugins = with pkgs.vimPlugins; [nvchad nvchad-ui];
}
