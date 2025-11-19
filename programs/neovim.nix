super @ {pkgs, ...}: {
  enable = true;
  viAlias = true;
  vimAlias = true;
  withNodeJs = false;
  plugins = with pkgs.vimPlugins; [nvchad nvchad-ui];
}
